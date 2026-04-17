import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/router/routes.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/features/auth/providers/auth_provider.dart';
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
    final colors = context.appColors;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // ── Header background using theme gradient colors ───────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 0.45.sh,
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
            child: RichText(
              text: TextSpan(
                style: textTheme.displaySmall?.copyWith(
                  color: scheme.onPrimary,
                  height: 1.35,
                ),
                children: [
                  const TextSpan(text: 'Log in to stay on\n'),
                  TextSpan(
                    text: 'top of ',
                    style: TextStyle(
                      color: scheme.onPrimary.withValues(alpha: 0.65),
                    ),
                  ),
                  const TextSpan(text: 'your tasks\nand projects.'),
                ],
              ),
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
                          key: authProvider.signInFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Title
                              Text(
                                'Login',
                                style: textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6.h),

                              // Sign up prompt
                              AuthPromptRow(
                                message: "Don't Have An Account? ",
                                actionText: 'Sign Up',
                                onTap: () => NavigationService.pushNamed(
                                  AppRoutes.signUp,
                                ),
                              ),
                              SizedBox(height: 24.h),

                              // Email field
                              CustomTextField(
                                textfieldBorderRadius: AppConstants.smallRadius,
                                hintText: 'name@example.com',
                                controller: authProvider.signInEmailController,
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
                              SizedBox(height: 12.h),

                              // Password field
                              CustomTextField(
                                textfieldBorderRadius: AppConstants.smallRadius,
                                hintText: 'Enter your password',
                                controller:
                                    authProvider.signInPasswordController,
                                obscureText:
                                    authProvider.isSignInPasswordHidden,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => authProvider.signIn(),
                                prefixIcon: CustomSvg(
                                  path: AppIconsSvg.lock,
                                  size: 20,
                                  color: colors.grey,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: authProvider
                                      .toggleSignInPasswordVisibility,
                                  icon: Icon(
                                    authProvider.isSignInPasswordHidden
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: colors.grey,
                                    size: 20.sp,
                                  ),
                                ),
                                validator: (value) => authProvider
                                    .validatePassword(context, value),
                              ),
                              SizedBox(height: 10.h),

                              // Remember me + Forgot password
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _RememberMe(),
                                  CustomTextButton(
                                    onPressed: () =>
                                        NavigationService.pushNamed(
                                          AppRoutes.forgotPassword,
                                        ),
                                    text: 'Forgot Password?',
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4.w,
                                      vertical: 6.h,
                                    ),
                                    backgroundColor: Colors.transparent,
                                    textStyle: textTheme.bodySmall?.copyWith(
                                      color: colors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),

                              // Login button
                              CustomButton(
                                text: 'Login',
                                onPressed: authProvider.signIn,
                                isLoading: authProvider.isSubmitting,
                              ),
                              SizedBox(height: 18.h),

                              // Divider
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(color: colors.lightGrey),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                    ),
                                    child: Text(
                                      'Or Continue With',
                                      style: textTheme.bodySmall?.copyWith(
                                        color: colors.grey,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(color: colors.lightGrey),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),

                              // Social buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: _SocialButton(
                                      label: 'Apple',
                                      icon: Icons.apple,
                                      bgColor: colors.secondary,
                                      labelColor: scheme.onPrimary,
                                      iconColor: scheme.onPrimary,
                                      onTap: () {},
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: _SocialButton(
                                      label: 'Google',
                                      googleLogo: true,
                                      bgColor: colors.lightGrey,
                                      labelColor: scheme.onSurface,
                                      iconColor: scheme.onSurface,
                                      borderColor: colors.bubbleGray,
                                      onTap: () {},
                                    ),
                                  ),
                                ],
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

// ── Remember Me ─────────────────────────────────────────────────────────────
class _RememberMe extends StatefulWidget {
  @override
  State<_RememberMe> createState() => _RememberMeState();
}

class _RememberMeState extends State<_RememberMe> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => setState(() => _checked = !_checked),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 18.w,
            height: 18.w,
            child: Checkbox(
              value: _checked,
              onChanged: (v) => setState(() => _checked = v ?? false),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r),
              ),
              side: BorderSide(color: colors.lightGrey),
              activeColor: scheme.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            'Remember Me',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colors.grey),
          ),
        ],
      ),
    );
  }
}

// ── Social button ────────────────────────────────────────────────────────────
class _SocialButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool googleLogo;
  final Color bgColor;
  final Color labelColor;
  final Color iconColor;
  final Color? borderColor;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    this.icon,
    this.googleLogo = false,
    required this.bgColor,
    required this.labelColor,
    required this.iconColor,
    this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(30.r),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (googleLogo)
              _GoogleIcon(size: 18.sp)
            else
              Icon(icon, color: iconColor, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              label,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: labelColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Google G icon ────────────────────────────────────────────────────────────
class _GoogleIcon extends StatelessWidget {
  final double size;
  const _GoogleIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double r = size.width / 2;

    final segments = [
      (0.0, 0.5, const Color(0xFF4285F4)),
      (0.5, 1.0, const Color(0xFF34A853)),
      (1.0, 1.5, const Color(0xFFFBBC05)),
      (1.5, 2.0, const Color(0xFFEA4335)),
    ];

    for (final seg in segments) {
      final paint = Paint()
        ..color = seg.$3
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.22
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.72),
        seg.$1 * 3.14159,
        (seg.$2 - seg.$1) * 3.14159,
        false,
        paint,
      );
    }

    // White crossbar for the "G"
    canvas.drawRect(
      Rect.fromLTWH(cx, cy - size.height * 0.1, r * 0.85, size.height * 0.2),
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
