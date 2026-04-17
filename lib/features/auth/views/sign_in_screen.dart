import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/router/routes.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/features/auth/providers/auth_provider.dart';
import 'package:avatar_flow/features/auth/views/components/auth_flow_shell.dart';
import 'package:avatar_flow/features/auth/views/components/auth_prompt_row.dart';
import 'package:avatar_flow/widgets/custom_button.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:avatar_flow/widgets/custom_text_button.dart';
import 'package:avatar_flow/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return AuthFlowShell(
          badgeText: 'Welcome back',
          badgeIcon: Icons.lock_open_rounded,
          title: 'Sign in to continue your story studio',
          subtitle:
              'Access saved avatars, continue story creation, and keep your child\'s adventures in sync.',
          footer: AuthPromptRow(
            message: 'New here?',
            actionText: 'Create an account',
            onTap: () {
              NavigationService.pushNamed(AppRoutes.signUp);
            },
          ),
          child: Form(
            key: authProvider.signInFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  textfieldBorderRadius: AppConstants.smallRadius,
                  title: 'Email',
                  hintText: 'name@example.com',
                  controller: authProvider.signInEmailController,
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: CustomSvg(
                    path: AppIconsSvg.lock,
                    size: 20,
                    color: context.appColors.grey,
                  ),
                  validator: (value) {
                    return authProvider.validateEmail(context, value);
                  },
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  textfieldBorderRadius: AppConstants.smallRadius,
                  title: 'Password',
                  hintText: 'Enter your password',
                  controller: authProvider.signInPasswordController,
                  obscureText: authProvider.isSignInPasswordHidden,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => authProvider.signIn(),
                  prefixIcon: CustomSvg(
                    path: AppIconsSvg.lock,
                    color: context.appColors.grey,
                    size: 20,
                  ),
                  suffixIcon: IconButton(
                    onPressed: authProvider.toggleSignInPasswordVisibility,
                    icon: Icon(
                      authProvider.isSignInPasswordHidden
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: context.appColors.grey,
                    ),
                  ),
                  validator: (value) {
                    return authProvider.validatePassword(context, value);
                  },
                ),
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomTextButton(
                    onPressed: () {
                      NavigationService.pushNamed(AppRoutes.forgotPassword);
                    },
                    text: 'Forgot password?',
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  text: 'Sign In',
                  onPressed: authProvider.signIn,
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
