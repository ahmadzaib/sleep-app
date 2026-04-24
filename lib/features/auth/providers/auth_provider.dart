import 'dart:async';

import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/router/routes.dart';
import 'package:avatar_flow/features/auth/services/auth_service.dart';
import 'package:avatar_flow/core/utils/toast_utils.dart';
import 'package:avatar_flow/core/utils/validator.dart';
import 'package:avatar_flow/features/auth/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthOtpFlow { signUp, resetPassword }

class AuthProvider extends ChangeNotifier with Validators {
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> forgotPasswordFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

  final TextEditingController signInEmailController = TextEditingController();
  final TextEditingController signInPasswordController =
      TextEditingController();
  final TextEditingController signUpNameController = TextEditingController();
  final TextEditingController signUpEmailController = TextEditingController();
  final TextEditingController signUpPasswordController =
      TextEditingController();
  final TextEditingController signUpConfirmPasswordController =
      TextEditingController();
  final TextEditingController forgotPasswordEmailController =
      TextEditingController();
  final TextEditingController resetPasswordController = TextEditingController();
  final TextEditingController resetConfirmPasswordController =
      TextEditingController();
  final TextEditingController otpController = TextEditingController();

  final List<TextInputFormatter> otpInputFormatters = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(8),
  ];

  bool _isSignInPasswordHidden = true;
  bool _isSignUpPasswordHidden = true;
  bool _isSignUpConfirmPasswordHidden = true;
  bool _isResetPasswordHidden = true;
  bool _isResetConfirmPasswordHidden = true;
  bool _isSubmitting = false;
  bool _isResendingCode = false;
  int _otpSecondsRemaining = 0;
  AuthOtpFlow _otpFlow = AuthOtpFlow.signUp;
  String _otpDestination = '';
  Timer? _otpTimer;
  UserModel? _currentUser;

  UserModel? get userInfo => _currentUser;

  bool get isSignInPasswordHidden => _isSignInPasswordHidden;
  bool get isSignUpPasswordHidden => _isSignUpPasswordHidden;
  bool get isSignUpConfirmPasswordHidden => _isSignUpConfirmPasswordHidden;
  bool get isResetPasswordHidden => _isResetPasswordHidden;
  bool get isResetConfirmPasswordHidden => _isResetConfirmPasswordHidden;
  bool get isSubmitting => _isSubmitting;
  bool get isResendingCode => _isResendingCode;
  int get otpSecondsRemaining => _otpSecondsRemaining;
  AuthOtpFlow get otpFlow => _otpFlow;
  String get otpDestination => _otpDestination;

  void toggleSignInPasswordVisibility() {
    _isSignInPasswordHidden = !_isSignInPasswordHidden;
    notifyListeners();
  }

  void toggleSignUpPasswordVisibility() {
    _isSignUpPasswordHidden = !_isSignUpPasswordHidden;
    notifyListeners();
  }

  void toggleSignUpConfirmPasswordVisibility() {
    _isSignUpConfirmPasswordHidden = !_isSignUpConfirmPasswordHidden;
    notifyListeners();
  }

  void toggleResetPasswordVisibility() {
    _isResetPasswordHidden = !_isResetPasswordHidden;
    notifyListeners();
  }

  void toggleResetConfirmPasswordVisibility() {
    _isResetConfirmPasswordHidden = !_isResetConfirmPasswordHidden;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    await _runWithLoading(() async {
      try {
        final response = await AuthService.signInWithGoogle();

        if (response.user != null) {
          _currentUser =
              await AuthService.getCurrentUser() ??
              UserModel(
                id: response.user!.id,
                email: response.user!.email ?? '',
                name:
                    response.user!.userMetadata?['full_name'] as String? ??
                    response.user!.userMetadata?['name'] as String?,
              );
          ToastUtils.success('Welcome ${_currentUser?.name ?? 'User'}!');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            NavigationService.goNamed(AppRoutes.bottomNavbar);
          });
        }
      } on AuthException catch (e) {
        ToastUtils.error(e.message);
      } catch (e) {
        ToastUtils.error('Google Sign-In failed. Please try again.');
      }
    });
  }

  Future<void> signIn() async {
    if (!(signInFormKey.currentState?.validate() ?? false)) return;

    await _runWithLoading(() async {
      try {
        final response = await AuthService.signIn(
          email: signInEmailController.text.trim(),
          password: signInPasswordController.text,
        );

        if (response.user != null) {
          _currentUser =
              await AuthService.getCurrentUser() ??
              UserModel(
                id: response.user!.id,
                email: response.user!.email ?? '',
                name: response.user!.userMetadata?['name'] as String?,
              );
          _clearSignInFields();
          ToastUtils.success('Welcome back!');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            NavigationService.goNamed(AppRoutes.bottomNavbar);
          });
        }
      } on AuthException catch (e) {
        ToastUtils.error(e.message);
      } catch (e) {
        ToastUtils.error('Sign in failed. Please try again.');
      }
    });
  }

  Future<void> signUp() async {
    if (!(signUpFormKey.currentState?.validate() ?? false)) return;

    final email = signUpEmailController.text.trim();
    final name = signUpNameController.text.trim();

    await _runWithLoading(() async {
      try {
        final response = await AuthService.signUp(
          email: email,
          password: signUpPasswordController.text,
          name: name,
        );

        if (response.user != null) {
          // Create user profile immediately on signup
          await AuthService.createUserProfile(
            id: response.user!.id,
            email: email,
            name: name,
          );

          final isConfirmed = response.user!.emailConfirmedAt != null;

          // If no session or unconfirmed, require email verification
          if (response.session == null || !isConfirmed) {
            configureOtp(flow: AuthOtpFlow.signUp, destination: email);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              NavigationService.pushNamed(
                AppRoutes.otpVerification,
                extra: {'flow': AuthOtpFlow.signUp.name, 'destination': email},
              );
            });
          } else {
            // Auto-confirmed (dev mode or disabled in Supabase)
            _currentUser = await AuthService.getCurrentUser();
            _clearSignUpFields();
            ToastUtils.success('Account created successfully!');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              NavigationService.goNamed(AppRoutes.bottomNavbar);
            });
          }
        }
      } on AuthException catch (e) {
        ToastUtils.error(e.message);
      } catch (e) {
        ToastUtils.error('Sign up failed. Please try again.');
      }
    });
  }

  Future<void> requestPasswordReset() async {
    if (!(forgotPasswordFormKey.currentState?.validate() ?? false)) return;

    await _runWithLoading(() async {
      try {
        await AuthService.sendRecoveryOTP(
          forgotPasswordEmailController.text.trim(),
        );
        ToastUtils.success('OTP sent to your email!');
        configureOtp(
          flow: AuthOtpFlow.resetPassword,
          destination: forgotPasswordEmailController.text.trim(),
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          NavigationService.pushNamed(
            AppRoutes.otpVerification,
            extra: {
              'flow': AuthOtpFlow.resetPassword.name,
              'destination': forgotPasswordEmailController.text.trim(),
            },
          );
        });
      } on AuthException catch (e) {
        ToastUtils.error(e.message);
      } catch (e) {
        ToastUtils.error('Failed to send OTP. Please try again.');
      }
    });
  }

  Future<void> verifyOtp() async {
    if (!(otpFormKey.currentState?.validate() ?? false)) {
      return;
    }

    await _runWithLoading(() async {
      try {
        final token = otpController.text.trim();
        final email = _otpDestination;
        final type = _otpFlow == AuthOtpFlow.signUp
            ? OtpType.signup
            : OtpType.recovery;

        await AuthService.verifyOTP(email: email, token: token, type: type);

        _otpTimer?.cancel();
        _otpSecondsRemaining = 0;

        if (_otpFlow == AuthOtpFlow.signUp) {
          // Email verified - account now active
          _currentUser =
              await AuthService.getCurrentUser() ??
              UserModel(
                id: AuthService.currentUser!.id,
                email: _otpDestination,
                name: AuthService.currentUser!.userMetadata?['name'] as String?,
              );
          _clearSignUpFields();
          otpController.clear();
          ToastUtils.success('Email verified! Welcome!');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            NavigationService.goNamed(AppRoutes.bottomNavbar);
          });
        } else {
          _clearForgotPasswordFields();
          otpController.clear();
          ToastUtils.success('You can now reset your password');
          // Defer navigation to avoid GlobalKey conflict during build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            NavigationService.goNamed(AppRoutes.resetPassword);
          });
        }
      } on AuthException catch (e) {
        ToastUtils.error(e.message);
      } catch (e) {
        ToastUtils.error('Verification failed. Please try again.');
      }
    });
  }

  Future<void> resetPassword() async {
    if (!(resetPasswordFormKey.currentState?.validate() ?? false)) {
      return;
    }

    final newPassword = resetPasswordController.text;

    await _runWithLoading(() async {
      try {
        await AuthService.updatePassword(newPassword);
        _clearResetPasswordFields();
        ToastUtils.success('Password updated successfully!');
        // Defer navigation to avoid GlobalKey conflict during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          NavigationService.goNamed(AppRoutes.signIn);
        });
      } on AuthException catch (e) {
        ToastUtils.error(e.message);
      } catch (e) {
        ToastUtils.error('Failed to reset password. Please try again.');
      }
    });
  }

  Future<void> resendOtp() async {
    if (_isResendingCode || _otpSecondsRemaining > 0) {
      return;
    }

    _isResendingCode = true;
    notifyListeners();

    try {
      if (_otpFlow == AuthOtpFlow.signUp) {
        // Resend email confirmation
        await AuthService.resendOTP(
          email: _otpDestination,
          type: OtpType.signup,
        );
      } else {
        // Resend recovery OTP
        await AuthService.sendRecoveryOTP(_otpDestination);
      }
      ToastUtils.success('Code resent!');
    } on AuthException catch (e) {
      ToastUtils.error(e.message);
    } catch (e) {
      ToastUtils.error('Failed to resend. Please try again.');
    }

    _isResendingCode = false;
    _startOtpCountdown();
    notifyListeners();
  }

  Future<void> signOut() async {
    await _runWithLoading(() async {
      await AuthService.signOut();
      _currentUser = null;
      ToastUtils.success('Signed out successfully');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        NavigationService.goNamed(AppRoutes.signIn);
      });
    });
  }

  Future<void> checkAuthStatus() async {
    try {
      if (AuthService.isAuthenticated()) {
        _currentUser = await AuthService.getCurrentUser();
        notifyListeners();
      }
    } catch (e) {
      // Invalid session/refresh token - clear local state
      _currentUser = null;
      notifyListeners();
    }
  }

  void configureOtp({required AuthOtpFlow flow, required String destination}) {
    _otpFlow = flow;
    _otpDestination = destination;
    otpController.clear();
    _startOtpCountdown();
    notifyListeners();
  }

  String get maskedOtpDestination {
    final String value = _otpDestination.trim();
    final int atIndex = value.indexOf('@');

    if (atIndex <= 1) {
      return value;
    }

    final String first = value.substring(0, 1);
    final String lastVisible = value.substring(atIndex - 1, atIndex);
    final String domain = value.substring(atIndex);
    return '$first${'*' * (atIndex - 2)}$lastVisible$domain';
  }

  String get resendButtonText {
    if (_otpSecondsRemaining == 0) {
      return 'Resend code';
    }

    final String formattedSeconds = _otpSecondsRemaining.toString().padLeft(
      2,
      '0',
    );
    return 'Resend in 00:$formattedSeconds';
  }

  Future<void> _runWithLoading(Future<void> Function() task) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      await task();
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void _startOtpCountdown() {
    _otpTimer?.cancel();
    _otpSecondsRemaining = 45;

    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_otpSecondsRemaining <= 1) {
        timer.cancel();
        _otpSecondsRemaining = 0;
      } else {
        _otpSecondsRemaining -= 1;
      }

      notifyListeners();
    });
  }

  void _clearSignInFields() {
    signInEmailController.clear();
    signInPasswordController.clear();
  }

  void _clearSignUpFields() {
    signUpNameController.clear();
    signUpEmailController.clear();
    signUpPasswordController.clear();
    signUpConfirmPasswordController.clear();
  }

  void _clearForgotPasswordFields() {
    forgotPasswordEmailController.clear();
  }

  void _clearResetPasswordFields() {
    resetPasswordController.clear();
    resetConfirmPasswordController.clear();
  }

  @override
  void dispose() {
    _otpTimer?.cancel();
    signInEmailController.dispose();
    signInPasswordController.dispose();
    signUpNameController.dispose();
    signUpEmailController.dispose();
    signUpPasswordController.dispose();
    signUpConfirmPasswordController.dispose();
    forgotPasswordEmailController.dispose();
    resetPasswordController.dispose();
    resetConfirmPasswordController.dispose();
    otpController.dispose();
    super.dispose();
  }
}
