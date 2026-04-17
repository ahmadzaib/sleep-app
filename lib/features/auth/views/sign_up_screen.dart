import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/router/routes.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/features/auth/providers/auth_provider.dart';
import 'package:avatar_flow/features/auth/views/components/auth_flow_shell.dart';
import 'package:avatar_flow/features/auth/views/components/auth_prompt_row.dart';
import 'package:avatar_flow/widgets/custom_button.dart';
import 'package:avatar_flow/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return AuthFlowShell(
          badgeText: 'Create account',
          badgeIcon: Icons.auto_stories_rounded,
          title: 'Build your family account in a minute',
          subtitle:
              'Set up your profile to save avatars, manage voice clones, and personalize story sessions.',
          footer: AuthPromptRow(
            message: 'Already have an account?',
            actionText: 'Sign in',
            onTap: () {
              NavigationService.pushNamed(AppRoutes.signIn);
            },
          ),
          child: Form(
            key: authProvider.signUpFormKey,
            child: Column(
              children: [
                CustomTextField(
                  title: 'Full name',
                  hintText: 'Enter your full name',
                  controller: authProvider.signUpNameController,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icon(
                    Icons.person_outline_rounded,
                    color: context.appColors.grey,
                  ),
                  validator: (value) {
                    return authProvider.validateName(context, value);
                  },
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  title: 'Email',
                  hintText: 'name@example.com',
                  controller: authProvider.signUpEmailController,
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icon(
                    Icons.mail_outline_rounded,
                    color: context.appColors.grey,
                  ),
                  validator: (value) {
                    return authProvider.validateEmail(context, value);
                  },
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  title: 'Password',
                  hintText: 'Create a strong password',
                  controller: authProvider.signUpPasswordController,
                  obscureText: authProvider.isSignUpPasswordHidden,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icon(
                    Icons.lock_outline_rounded,
                    color: context.appColors.grey,
                  ),
                  suffixIcon: IconButton(
                    onPressed: authProvider.toggleSignUpPasswordVisibility,
                    icon: Icon(
                      authProvider.isSignUpPasswordHidden
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
                  title: 'Confirm password',
                  hintText: 'Re-enter your password',
                  controller: authProvider.signUpConfirmPasswordController,
                  obscureText: authProvider.isSignUpConfirmPasswordHidden,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => authProvider.signUp(),
                  prefixIcon: Icon(
                    Icons.verified_user_outlined,
                    color: context.appColors.grey,
                  ),
                  suffixIcon: IconButton(
                    onPressed:
                        authProvider.toggleSignUpConfirmPasswordVisibility,
                    icon: Icon(
                      authProvider.isSignUpConfirmPasswordHidden
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: context.appColors.grey,
                    ),
                  ),
                  validator: (value) {
                    return authProvider.validateConfirmPassword(
                      context,
                      value,
                      authProvider.signUpPasswordController.text,
                    );
                  },
                ),
                SizedBox(height: 24.h),
                CustomButton(
                  text: 'Create Account',
                  onPressed: authProvider.signUp,
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
