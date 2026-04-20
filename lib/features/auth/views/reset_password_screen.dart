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

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return AuthFlowShell(
          badgeText: 'New Credentials',
          badgeIcon: Icons.lock_reset_rounded,
          title: 'Reset password',
          subtitle:
              'Choose a secure and memorable password to protect your account.',
          footer: AuthPromptRow(
            message: 'Remembered it?',
            actionText: 'Back to sign in',
            onTap: () {
              NavigationService.pop();
            },
          ),
          child: Form(
            key: authProvider.resetPasswordFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  textfieldBorderRadius: AppConstants.smallRadius,
                  title: 'New Password',
                  hintText: 'Enter your new password',
                  controller: authProvider.resetPasswordController,
                  obscureText: authProvider.isResetPasswordHidden,
                  textInputAction: TextInputAction.next,
                  prefixIcon: CustomSvg(
                    path: AppIconsSvg.lock,
                    color: context.appColors.grey,
                    size: 20,
                  ),
                  suffixIcon: IconButton(
                    onPressed: authProvider.toggleResetPasswordVisibility,
                    icon: Icon(
                      authProvider.isResetPasswordHidden
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: context.appColors.grey,
                    ),
                  ),
                  validator: (value) {
                    return authProvider.validatePassword(context, value);
                  },
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  textfieldBorderRadius: AppConstants.smallRadius,
                  title: 'Confirm New Password',
                  hintText: 'Confirm your new password',
                  controller: authProvider.resetConfirmPasswordController,
                  obscureText: authProvider.isResetConfirmPasswordHidden,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => authProvider.resetPassword(),
                  prefixIcon: CustomSvg(
                    path: AppIconsSvg.lock,
                    color: context.appColors.grey,
                    size: 20,
                  ),
                  suffixIcon: IconButton(
                    onPressed: authProvider.toggleResetConfirmPasswordVisibility,
                    icon: Icon(
                      authProvider.isResetConfirmPasswordHidden
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: context.appColors.grey,
                    ),
                  ),
                  validator: (value) {
                    return authProvider.validateConfirmPassword(
                      context,
                      value,
                      authProvider.resetPasswordController.text,
                    );
                  },
                ),
                SizedBox(height: 24.h),
                CustomButton(
                  text: 'Update Password',
                  onPressed: authProvider.resetPassword,
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
