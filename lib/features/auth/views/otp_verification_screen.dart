import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/auth/providers/auth_provider.dart';
import 'package:avatar_flow/widgets/custom_button.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:avatar_flow/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    super.key,
    required this.flow,
    required this.destination,
  });

  final AuthOtpFlow flow;
  final String destination;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AuthProvider>().configureOtp(
        flow: widget.flow,
        destination: widget.destination,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // ── Gradient header ────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 0.38.sh,
            child: Container(
              decoration: BoxDecoration(
                gradient: AppConstants.defaultGradient(context),
              ),
            ),
          ),

          // ── Header text ────────────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 16.h,
            left: 24.w,
            right: 24.w,
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                final isReset =
                    authProvider.otpFlow == AuthOtpFlow.resetPassword;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: scheme.onPrimary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: CustomSvg(
                          path: 'assets/icons/arrow_back.svg',
                          size: 20,
                          color: scheme.onPrimary,
                        ),
                      ),
                    ),
                    Spacing.y(2),
                    RichText(
                      text: TextSpan(
                        style: textTheme.displaySmall?.copyWith(
                          color: scheme.onPrimary,
                          height: 1.35,
                        ),
                        children: [
                          TextSpan(
                            text: isReset ? 'Reset your\n' : 'Verify your\n',
                          ),
                          TextSpan(
                            text: 'StoryPal ',
                            style: TextStyle(
                              color: scheme.onPrimary.withValues(alpha: 0.65),
                            ),
                          ),
                          const TextSpan(text: 'account.'),
                        ],
                      ),
                    ),
                    Spacing.y(1),
                    Text(
                      isReset
                          ? "We've sent a 6-digit code to reset your password."
                          : "We've sent a 6-digit code to activate your account.",
                      style: textTheme.bodySmall?.copyWith(
                        color: scheme.onPrimary.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // ── Keyboard-aware bottom card ─────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: 0.62.sh,
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.secondary.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 32.h),
                    child: Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return Form(
                          key: authProvider.otpFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Enter OTP',
                                style: textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacing.y(0.8),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colors.grey,
                                  ),
                                  children: [
                                    const TextSpan(text: 'Code sent to '),
                                    TextSpan(
                                      text: authProvider.maskedOtpDestination,
                                      style: TextStyle(
                                        color: scheme.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacing.y(3),

                              // OTP input
                              _OtpInputField(authProvider: authProvider),
                              Spacing.y(1),

                              // Timer row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.timer_outlined,
                                    size: 16.r,
                                    color: colors.grey,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    authProvider.otpSecondsRemaining == 0
                                        ? 'Code expired. Request a new one.'
                                        : 'Code expires in 00:${authProvider.otpSecondsRemaining.toString().padLeft(2, '0')}',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Spacing.y(3),

                              CustomButton(
                                text: 'Verify Code',
                                onPressed: authProvider.verifyOtp,
                                isLoading: authProvider.isSubmitting,
                              ),
                              Spacing.y(1.2),

                              CustomTextButton(
                                onPressed:
                                    authProvider.otpSecondsRemaining == 0 &&
                                        !authProvider.isResendingCode
                                    ? authProvider.resendOtp
                                    : null,
                                text: authProvider.isResendingCode
                                    ? 'Sending...'
                                    : authProvider.resendButtonText,
                                backgroundColor: Colors.transparent,
                                textStyle: textTheme.headlineSmall?.copyWith(
                                  color: authProvider.otpSecondsRemaining == 0
                                      ? scheme.primary
                                      : colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── OTP pin input ────────────────────────────────────────────────────────────
class _OtpInputField extends StatelessWidget {
  const _OtpInputField({required this.authProvider});

  final AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final double radius = AppConstants.largeRadius;

    final fieldStyle = theme.textTheme.titleSmall!.copyWith(
      color: theme.textTheme.titleMedium?.color,
    );
    final hintStyle = theme.textTheme.titleSmall!.copyWith(color: colors.grey);
    final errorStyle = theme.textTheme.titleSmall!.copyWith(
      color: theme.colorScheme.error,
      height: 1.35,
    );

    final base = PinTheme(
      width: 48.w,
      height: 56.h,
      textStyle: fieldStyle,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: colors.lightGrey),
      ),
    );

    return Pinput(
      length: 6,
      controller: authProvider.otpController,
      defaultPinTheme: base,
      focusedPinTheme: base.copyWith(
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: theme.colorScheme.primary),
        ),
      ),
      submittedPinTheme: base,
      errorPinTheme: base.copyBorderWith(
        border: Border.all(color: theme.colorScheme.error),
      ),
      followingPinTheme: base,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      inputFormatters: authProvider.otpInputFormatters,
      validator: (value) => authProvider.validateOtp(context, value),
      onCompleted: (_) => authProvider.verifyOtp(),
      onSubmitted: (_) => authProvider.verifyOtp(),
      separatorBuilder: (index) => SizedBox(width: 8.w),
      cursor: Container(
        width: 1.5.w,
        height: 20.h,
        color: theme.colorScheme.primary,
      ),
      errorTextStyle: errorStyle,
      preFilledWidget: Center(child: Text('0', style: hintStyle)),
    );
  }
}
