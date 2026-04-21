import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/features/auth/providers/auth_provider.dart';
import 'package:avatar_flow/features/auth/views/components/auth_flow_shell.dart';
import 'package:avatar_flow/features/auth/views/components/auth_prompt_row.dart';
import 'package:avatar_flow/widgets/custom_button.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:avatar_flow/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return AuthFlowShell(
          badgeText: 'Recover access',
          badgeIcon: Icons.mark_email_unread_outlined,
          title: 'Forgot your password?',
          subtitle:
              'Enter the email tied to your account and we\'ll send a one-time verification code.',
          footer: AuthPromptRow(
            message: 'Remembered it?',
            actionText: 'Back to sign in',
            onTap: () {
              NavigationService.pop();
            },
          ),
          child: Form(
            key: authProvider.forgotPasswordFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  textfieldBorderRadius: AppConstants.smallRadius,
                  title: 'Email',
                  hintText: 'name@example.com',
                  controller: authProvider.forgotPasswordEmailController,
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => authProvider.requestPasswordReset(),
                  prefixIcon: CustomSvg(
                    path: AppIconsSvg.email,
                    size: 20,
                    color: context.appColors.grey,
                  ),
                  validator: (value) {
                    return authProvider.validateEmail(context, value);
                  },
                ),

                SizedBox(height: 24.h),
                CustomButton(
                  text: 'Send OTP',
                  onPressed: authProvider.requestPasswordReset,
                  isLoading: authProvider.isSubmitting,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
