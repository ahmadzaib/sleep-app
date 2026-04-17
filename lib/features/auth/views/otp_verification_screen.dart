import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/router/routes.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/auth/providers/auth_provider.dart';
import 'package:avatar_flow/features/auth/views/components/auth_flow_shell.dart';
import 'package:avatar_flow/features/auth/views/components/auth_prompt_row.dart';
import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/widgets/custom_button.dart';
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
      if (!mounted) {
        return;
      }

      context.read<AuthProvider>().configureOtp(
        flow: widget.flow,
        destination: widget.destination,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final bool isResetFlow =
            authProvider.otpFlow == AuthOtpFlow.resetPassword;

        return AuthFlowShell(
          badgeText: isResetFlow ? 'Check your inbox' : 'Verify account',
          badgeIcon: isResetFlow
              ? Icons.verified_user_outlined
              : Icons.verified_rounded,
          title: isResetFlow
              ? 'Enter the recovery code'
              : 'Confirm your sign up code',
          subtitle: isResetFlow
              ? 'We sent a six-digit code to ${authProvider.maskedOtpDestination}. Verify it to continue your password recovery journey.'
              : 'A verification code was sent to ${authProvider.maskedOtpDestination}. Enter it below to activate your account.',
          footer: AuthPromptRow(
            message: isResetFlow
                ? 'Used the wrong email?'
                : 'Need to update details?',
            actionText: isResetFlow ? 'Try again' : 'Back to sign up',
            onTap: () {
              NavigationService.pushNamed(
                isResetFlow ? AppRoutes.forgotPassword : AppRoutes.signUp,
              );
            },
          ),
          child: Form(
            key: authProvider.otpFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _OtpInputField(authProvider: authProvider),
                Spacing.y(4),
                Text(
                  'OTP code',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(fontSize: 13.sp),
                ),
                Spacing.y(1),
                Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 18.r,
                      color: context.appColors.grey,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        authProvider.otpSecondsRemaining == 0
                            ? 'The code expired? Request a fresh one below.'
                            : 'Your current code remains active for 00:${authProvider.otpSecondsRemaining.toString().padLeft(2, '0')}.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.appColors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                CustomButton(
                  text: 'Verify Code',
                  onPressed: authProvider.verifyOtp,
                  isLoading: authProvider.isSubmitting,
                ),
                SizedBox(height: 10.h),
                Center(
                  child: CustomTextButton(
                    onPressed:
                        authProvider.otpSecondsRemaining == 0 &&
                            !authProvider.isResendingCode
                        ? authProvider.resendOtp
                        : null,
                    text: authProvider.isResendingCode
                        ? 'Sending...'
                        : authProvider.resendButtonText,
                    backgroundColor: Colors.transparent,
                    textStyle: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(
                          color: authProvider.otpSecondsRemaining == 0
                              ? context.appColors.primary
                              : context.appColors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OtpInputField extends StatelessWidget {
  const _OtpInputField({required this.authProvider});

  final AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppColorsExtension colors = context.appColors;
    final double radius = AppConstants.smallRadius;

    final TextStyle fieldStyle = theme.textTheme.titleSmall!.copyWith(
      color: theme.textTheme.titleMedium?.color,
    );
    final TextStyle hintStyle = theme.textTheme.titleSmall!.copyWith(
      color: colors.grey,
    );
    final TextStyle errorStyle = theme.textTheme.titleSmall!.copyWith(
      color: theme.colorScheme.error,
      height: 1.35,
    );

    PinTheme baseTheme = PinTheme(
      width: 48.w,
      height: 56.h,
      textStyle: fieldStyle,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: colors.lightGrey),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Pinput(
          length: 6,
          controller: authProvider.otpController,
          defaultPinTheme: baseTheme,
          focusedPinTheme: baseTheme.copyWith(
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: theme.colorScheme.primary),
            ),
          ),
          submittedPinTheme: baseTheme,
          errorPinTheme: baseTheme.copyBorderWith(
            border: Border.all(color: theme.colorScheme.error),
          ),
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          showCursor: true,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          inputFormatters: authProvider.otpInputFormatters,
          validator: (value) {
            return authProvider.validateOtp(context, value);
          },
          onCompleted: (_) => authProvider.verifyOtp(),
          onSubmitted: (_) => authProvider.verifyOtp(),
          followingPinTheme: baseTheme.copyWith(
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: colors.lightGrey),
            ),
          ),
          separatorBuilder: (index) => SizedBox(width: 8.w),
          cursor: Container(
            width: 1.5.w,
            height: 20.h,
            color: theme.colorScheme.primary,
          ),
          errorTextStyle: errorStyle,
          preFilledWidget: Center(child: Text('0', style: hintStyle)),
        ),
      ],
    );
  }
}
