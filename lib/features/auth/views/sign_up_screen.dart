import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/router/routes.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/auth/providers/auth_provider.dart';
import 'package:avatar_flow/features/auth/views/components/auth_prompt_row.dart';
import 'package:avatar_flow/widgets/custom_button.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:avatar_flow/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: textTheme.displaySmall?.copyWith(
                      color: scheme.onPrimary,
                      height: 1.35,
                    ),
                    children: [
                      const TextSpan(text: 'Create your\n'),
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
                  'Bring your stories to life with AI avatars.',
                  style: textTheme.bodySmall?.copyWith(
                    color: scheme.onPrimary.withValues(alpha: 0.75),
                  ),
                ),
              ],
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
                          key: authProvider.signUpFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Sign Up',
                                style: textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacing.y(0.8),
                              AuthPromptRow(
                                message: 'Already have an account? ',
                                actionText: 'Sign In',
                                onTap: () => NavigationService.pushNamed(
                                  AppRoutes.signIn,
                                ),
                              ),
                              Spacing.y(2.5),

                              // Full name
                              CustomTextField(
                                textfieldBorderRadius: AppConstants.smallRadius,
                                hintText: 'Your storyteller name',
                                controller: authProvider.signUpNameController,
                                textInputAction: TextInputAction.next,
                                prefixIcon: CustomSvg(
                                  path: AppIconsSvg.user,
                                  size: 20,
                                  color: colors.grey,
                                ),
                                validator: (value) =>
                                    authProvider.validateName(context, value),
                              ),
                              Spacing.y(1.5),

                              // Email
                              CustomTextField(
                                textfieldBorderRadius: AppConstants.smallRadius,
                                hintText: 'name@example.com',
                                controller: authProvider.signUpEmailController,
                                textInputType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                prefixIcon: CustomSvg(
                                  path: AppIconsSvg.email,
                                  size: 20,
                                  color: colors.grey,
                                ),
                                validator: (value) =>
                                    authProvider.validateEmail(context, value),
                              ),
                              Spacing.y(1.5),

                              // Password
                              CustomTextField(
                                textfieldBorderRadius: AppConstants.smallRadius,
                                hintText: 'Create a strong password',
                                controller:
                                    authProvider.signUpPasswordController,
                                obscureText:
                                    authProvider.isSignUpPasswordHidden,
                                textInputAction: TextInputAction.next,
                                prefixIcon: CustomSvg(
                                  path: AppIconsSvg.lock,
                                  size: 20,
                                  color: colors.grey,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: authProvider
                                      .toggleSignUpPasswordVisibility,
                                  icon: Icon(
                                    authProvider.isSignUpPasswordHidden
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: colors.grey,
                                    size: 20.sp,
                                  ),
                                ),
                                validator: (value) => authProvider
                                    .validatePassword(context, value),
                              ),
                              Spacing.y(1.5),

                              // Confirm password
                              CustomTextField(
                                textfieldBorderRadius: AppConstants.smallRadius,
                                hintText: 'Re-enter your password',
                                controller: authProvider
                                    .signUpConfirmPasswordController,
                                obscureText:
                                    authProvider.isSignUpConfirmPasswordHidden,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => authProvider.signUp(),
                                prefixIcon: CustomSvg(
                                  path: AppIconsSvg.lock,
                                  size: 20,
                                  color: colors.grey,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: authProvider
                                      .toggleSignUpConfirmPasswordVisibility,
                                  icon: Icon(
                                    authProvider.isSignUpConfirmPasswordHidden
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: colors.grey,
                                    size: 20.sp,
                                  ),
                                ),
                                validator: (value) =>
                                    authProvider.validateConfirmPassword(
                                      context,
                                      value,
                                      authProvider
                                          .signUpPasswordController
                                          .text,
                                    ),
                              ),
                              Spacing.y(2.5),

                              CustomButton(
                                text: 'Create Account',
                                onPressed: authProvider.signUp,
                                isLoading: authProvider.isSubmitting,
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
