import 'dart:async';

import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/router/routes.dart';
import 'package:avatar_flow/core/services/auth_service.dart';
import 'package:avatar_flow/core/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  Future<void> signIn() async {
    if (!(signInFormKey.currentState?.validate() ?? false)) {
      return;
    }

    await _runWithLoading(() async {
      await Future<void>.delayed(const Duration(milliseconds: 850));
      await AuthService.saveAuthData(accessToken: 'demo-access-token');
      _clearSignInFields();
      NavigationService.goNamed(AppRoutes.bottomNavbar);
    });
  }

  Future<void> signUp() async {
    if (!(signUpFormKey.currentState?.validate() ?? false)) {
      return;
    }

    final String email = signUpEmailController.text.trim();

    await _runWithLoading(() async {
      await Future<void>.delayed(const Duration(milliseconds: 900));
      configureOtp(flow: AuthOtpFlow.signUp, destination: email);
      NavigationService.pushNamed(
        AppRoutes.otpVerification,
        extra: {'flow': AuthOtpFlow.signUp.name, 'destination': email},
      );
    });
  }

  Future<void> requestPasswordReset() async {
    if (!(forgotPasswordFormKey.currentState?.validate() ?? false)) {
      return;
    }

    final String email = forgotPasswordEmailController.text.trim();

    await _runWithLoading(() async {
      await Future<void>.delayed(const Duration(milliseconds: 850));
      configureOtp(flow: AuthOtpFlow.resetPassword, destination: email);
      NavigationService.pushNamed(
        AppRoutes.otpVerification,
        extra: {'flow': AuthOtpFlow.resetPassword.name, 'destination': email},
      );
    });
  }

  Future<void> verifyOtp() async {
    if (!(otpFormKey.currentState?.validate() ?? false)) {
      return;
    }

    await _runWithLoading(() async {
      await Future<void>.delayed(const Duration(milliseconds: 850));
      _otpTimer?.cancel();
      _otpSecondsRemaining = 0;

      if (_otpFlow == AuthOtpFlow.signUp) {
        await AuthService.saveAuthData(accessToken: 'verified-demo-token');
        _clearSignUpFields();
        otpController.clear();
        NavigationService.goNamed(AppRoutes.bottomNavbar);
        return;
      }

      _clearForgotPasswordFields();
      otpController.clear();
      NavigationService.goNamed(AppRoutes.signIn);
    });
  }

  Future<void> resendOtp() async {
    if (_isResendingCode || _otpSecondsRemaining > 0) {
      return;
    }

    _isResendingCode = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 700));

    _isResendingCode = false;
    _startOtpCountdown();
    notifyListeners();
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
