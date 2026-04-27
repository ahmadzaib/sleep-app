import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/widgets/bg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthFlowShell extends StatelessWidget {
  const AuthFlowShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    required this.badgeText,
    required this.badgeIcon,
    this.footer,
  });

  final String title;
  final String subtitle;
  final String badgeText;
  final IconData badgeIcon;
  final Widget child;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: AppConstants.defaultAllPadding.copyWith(
              top: 12.h,
              bottom: 24.h + bottomInset,
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(22.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppConstants.mediumRadius),

                boxShadow: [AppConstants.defaultShadow],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: context.appColors.primary.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          badgeIcon,
                          size: 18.r,
                          color: context.appColors.primary,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          badgeText,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: context.appColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacing.y(2.5),
                  Row(
                    children: [
                      Container(
                        height: 56.r,
                        width: 56.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.surface,
                          boxShadow: [AppConstants.defaultShadow],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12.r),
                          child: Image.asset(AppImagesPng.appLogo),
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontSize: 28.sp,
                            height: 1.15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacing.y(1.8),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: context.appColors.grey,
                      height: 1.45,
                    ),
                  ),
                  Spacing.y(3),
                  child,
                  if (footer != null) ...[Spacing.y(2.2), footer!],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
