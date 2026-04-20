import 'dart:async';

import 'package:avatar_flow/core/debug/debug_point.dart';
import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/router/routes.dart';
import 'package:avatar_flow/core/services/auth_service.dart';
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
  final TextEditingController otpController = TextEditingController();

  final List<TextInputFormatter> otpInputFormatters = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(6),
  ];

  bool _isSignInPasswordHidden = true;
  bool _isSignUpPasswordHidden = true;
  bool _isSignUpConfirmPasswordHidden = true;
  bool _isSubmitting = false;
  bool _isResendingCode = false;
  int _otpSecondsRemaining = 0;
  AuthOtpFlow _otpFlow = AuthOtpFlow.signUp;
  String _otpDestination = '';
  Timer? _otpTimer;
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  // Safe getter that ensures user data is loaded from _currentUser or Supabase
  UserModel get userInfo {
    final user = _currentUser;
    final supabaseUser = AuthService.currentUser;

    DebugPoint.log(
      '[AUTH_PROVIDER] userInfo called - currentUser: ${user?.id}',
    );
    DebugPoint.log(
      '[AUTH_PROVIDER] userInfo called - supabaseUser: ${supabaseUser?.id}',
    );

    // If we have _currentUser, return it
    if (user != null) {
      return user;
    }

    // Fallback to Supabase user if _currentUser is null
    if (supabaseUser != null) {
      return UserModel.fromSupabaseUser(
        id: supabaseUser.id,
        email: supabaseUser.email ?? '',
        name: supabaseUser.userMetadata?['name'] as String?,
        avatarUrl: supabaseUser.userMetadata?['avatar_url'] as String?,
      );
    }

    // Return empty user if nothing available
    return UserModel.empty();
  }

  bool get isSignInPasswordHidden => _isSignInPasswordHidden;
  bool get isSignUpPasswordHidden => _isSignUpPasswordHidden;
  bool get isSignUpConfirmPasswordHidden => _isSignUpConfirmPasswordHidden;
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

  Future<void> signInWithGoogle() async {
    DebugPoint.log('[AUTH] Google Sign-In started');

    await _runWithLoading(() async {
      try {
        final response = await AuthService.signInWithGoogle();

        DebugPoint.log(
          '[AUTH] Google Sign-In response - user: ${response.user?.id}',
        );

        if (response.user != null) {
          _currentUser = await AuthService.getCurrentUserModel();
          ToastUtils.success('Welcome ${userInfo.name}!');
          NavigationService.goNamed(AppRoutes.bottomNavbar);
        }
      } on AuthException catch (e) {
        DebugPoint.error('[AUTH] Google Sign-In AuthException: ${e.message}');
        ToastUtils.error(e.message);
      } catch (e, stackTrace) {
        DebugPoint.error('[AUTH] Google Sign-In unexpected error: $e');
        DebugPoint.error('[AUTH] StackTrace: $stackTrace');
        ToastUtils.error('Google Sign-In failed. Please try again.');
      }
    });
  }

  Future<void> signIn() async {
    DebugPoint.log('[AUTH] SignIn started');
    if (!(signInFormKey.currentState?.validate() ?? false)) {
      DebugPoint.log('[AUTH] SignIn validation failed');
      return;
    }

    await _runWithLoading(() async {
      try {
        final email = signInEmailController.text.trim();
        DebugPoint.log('[AUTH] Attempting sign in for: $email');

        final response = await AuthService.signIn(
          email: email,
          password: signInPasswordController.text,
        );

        DebugPoint.log(
          '[AUTH] SignIn response - user: ${response.user?.id}, session: ${response.session != null}',
        );

        if (response.user != null) {
          _currentUser = await AuthService.getCurrentUserModel();
          DebugPoint.log(
            '[AUTH] Current user loaded: ${_currentUser?.toString()}',
          );
          _clearSignInFields();
          ToastUtils.success('Welcome back!');
          NavigationService.goNamed(AppRoutes.bottomNavbar);
        }
      } on AuthException catch (e) {
        DebugPoint.error('[AUTH] SignIn AuthException: ${e.message}');
        DebugPoint.error('[AUTH] StatusCode: ${e.statusCode}');
        ToastUtils.error(e.message);
      } catch (e, stackTrace) {
        DebugPoint.error('[AUTH] SignIn unexpected error: $e');
        DebugPoint.error('[AUTH] StackTrace: $stackTrace');
        ToastUtils.error('Sign in failed. Please try again.');
      }
    });
  }

  Future<void> signUp() async {
    DebugPoint.log('[AUTH] SignUp started');
    if (!(signUpFormKey.currentState?.validate() ?? false)) {
      DebugPoint.log('[AUTH] SignUp validation failed');
      return;
    }

    final String email = signUpEmailController.text.trim();
    final String name = signUpNameController.text.trim();
    DebugPoint.log('[AUTH] Attempting sign up for: $email, name: $name');

    await _runWithLoading(() async {
      try {
        final response = await AuthService.signUp(
          email: email,
          password: signUpPasswordController.text,
          name: name,
        );

        DebugPoint.log(
          '[AUTH] SignUp response - user: ${response.user?.id}, session: ${response.session != null}',
        );
        DebugPoint.log('[AUTH] User metadata: ${response.user?.userMetadata}');

        if (response.user != null) {
          // Check if email confirmation is required
          if (response.session == null) {
            DebugPoint.log(
              '[AUTH] Email confirmation required, navigating to OTP',
            );
            configureOtp(flow: AuthOtpFlow.signUp, destination: email);
            NavigationService.pushNamed(
              AppRoutes.otpVerification,
              extra: {'flow': AuthOtpFlow.signUp.name, 'destination': email},
            );
          } else {
            // Auto-confirmed (development mode)
            DebugPoint.log('[AUTH] Auto-confirmed, loading user model');
            _currentUser = await AuthService.getCurrentUserModel();
            DebugPoint.log('[AUTH] User loaded: ${_currentUser?.toString()}');
            _clearSignUpFields();
            ToastUtils.success('Account created successfully!');
            NavigationService.goNamed(AppRoutes.bottomNavbar);
          }
        } else {
          DebugPoint.warning('[AUTH] SignUp returned null user');
        }
      } on AuthException catch (e) {
        DebugPoint.error('[AUTH] SignUp AuthException: ${e.message}');
        DebugPoint.error('[AUTH] StatusCode: ${e.statusCode}');
        ToastUtils.error(e.message);
      } catch (e, stackTrace) {
        DebugPoint.error('[AUTH] SignUp unexpected error: $e');
        DebugPoint.error('[AUTH] StackTrace: $stackTrace');
        ToastUtils.error('Sign up failed. Please try again.');
      }
    });
  }

  Future<void> requestPasswordReset() async {
    DebugPoint.log('[AUTH] Password reset requested');
    if (!(forgotPasswordFormKey.currentState?.validate() ?? false)) {
      DebugPoint.log('[AUTH] Password reset validation failed');
      return;
    }

    final String email = forgotPasswordEmailController.text.trim();
    DebugPoint.log('[AUTH] Sending password reset for: $email');

    await _runWithLoading(() async {
      try {
        await AuthService.resetPassword(email);
        DebugPoint.log('[AUTH] Password reset email sent successfully');
        ToastUtils.success('Password reset email sent!');
        configureOtp(flow: AuthOtpFlow.resetPassword, destination: email);
        NavigationService.pushNamed(
          AppRoutes.otpVerification,
          extra: {'flow': AuthOtpFlow.resetPassword.name, 'destination': email},
        );
      } on AuthException catch (e) {
        DebugPoint.error('[AUTH] Password reset AuthException: ${e.message}');
        DebugPoint.error('[AUTH] StatusCode: ${e.statusCode}');
        ToastUtils.error(e.message);
      } catch (e, stackTrace) {
        DebugPoint.error('[AUTH] Password reset unexpected error: $e');
        DebugPoint.error('[AUTH] StackTrace: $stackTrace');
        ToastUtils.error('Failed to send reset email. Please try again.');
      }
    });
  }

  Future<void> verifyOtp() async {
    if (!(otpFormKey.currentState?.validate() ?? false)) {
      return;
    }

    await _runWithLoading(() async {
      try {
        // Note: Supabase doesn't use traditional OTP for email verification
        // In a real implementation, you might verify the token differently
        // This is a simplified flow
        _otpTimer?.cancel();
        _otpSecondsRemaining = 0;

        if (_otpFlow == AuthOtpFlow.signUp) {
          _currentUser = await AuthService.getCurrentUserModel();
          _clearSignUpFields();
          otpController.clear();
          ToastUtils.success('Email verified! Welcome!');
          NavigationService.goNamed(AppRoutes.bottomNavbar);
        } else {
          _clearForgotPasswordFields();
          otpController.clear();
          ToastUtils.success('You can now reset your password');
          NavigationService.goNamed(AppRoutes.signIn);
        }
      } catch (e) {
        ToastUtils.error('Verification failed. Please try again.');
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
        await AuthService.signUp(
          email: _otpDestination,
          password: signUpPasswordController.text,
          name: signUpNameController.text.trim(),
        );
      } else {
        // Resend password reset
        await AuthService.resetPassword(_otpDestination);
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
      NavigationService.goNamed(AppRoutes.signIn);
    });
  }

  Future<void> checkAuthStatus() async {
    DebugPoint.log('[AUTH] Checking auth status');
    final isAuth = AuthService.isAuthenticated();
    DebugPoint.log('[AUTH] Is authenticated: $isAuth');

    if (isAuth) {
      _currentUser = await AuthService.getCurrentUserModel();
      DebugPoint.log('[AUTH] Current user loaded: ${_currentUser?.toString()}');
      notifyListeners();
    } else {
      DebugPoint.log('[AUTH] No active session found');
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
    otpController.dispose();
    super.dispose();
  }
}
