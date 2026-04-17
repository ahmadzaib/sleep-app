import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/constants/keys.dart';
import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/router/routes.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/widgets/custom_cache_netword_imge.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: textTheme.headlineMedium),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: CustomSvg(
            path: AppIconsSvg.arrowBack,
            size: 22,
            color: colors.iconColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 28.h),
              decoration: BoxDecoration(
                gradient: AppConstants.defaultGradient(context),
              ),
              child: Column(
                children: [
                  // Avatar
                  Stack(
                    children: [
                      CustomCachedNetworkImage(
                        imageUrl: Keys.placeHolderImage,
                        height: 90.h,
                        width: 90.w,
                        borderRadius: 90.r,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            color: scheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: CustomSvg(
                            path: AppIconsSvg.edit2,
                            size: 12,
                            color: scheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacing.y(1.5),
                  Text(
                    'Sarah Johnson',
                    style: textTheme.headlineMedium?.copyWith(
                      color: scheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacing.y(0.5),
                  Text(
                    'sarah@example.com',
                    style: textTheme.bodySmall?.copyWith(
                      color: scheme.onPrimary.withValues(alpha: 0.75),
                    ),
                  ),
                  Spacing.y(2),
                  // Subscription badge
                  GestureDetector(
                    onTap: () =>
                        NavigationService.pushNamed(AppRoutes.subscription),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.onPrimary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(
                          AppConstants.extraLargeRadius,
                        ),
                        border: Border.all(
                          color: scheme.onPrimary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(AppImagesPng.badge, height: 18.h),
                          SizedBox(width: 8.w),
                          Text(
                            'Free Plan  •  Upgrade',
                            style: textTheme.bodySmall?.copyWith(
                              color: scheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          CustomSvg(
                            path: AppIconsSvg.arrowForward,
                            size: 14,
                            color: scheme.onPrimary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Stats row ────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Row(
                children: [
                  _StatCard(
                    value: '12',
                    label: 'Avatars',
                    icon: AppIconsSvg.user,
                  ),
                  SizedBox(width: 12.w),
                  _StatCard(
                    value: '48',
                    label: 'Stories',
                    icon: AppIconsSvg.book,
                  ),
                  SizedBox(width: 12.w),
                  _StatCard(
                    value: '4.5',
                    label: 'Rating',
                    icon: AppIconsSvg.heart,
                  ),
                ],
              ),
            ),

            // ── Menu items ───────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  _SectionLabel('Account', textTheme, colors),
                  _MenuItem(
                    icon: AppIconsSvg.edit,
                    label: 'Edit Profile',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: AppIconsSvg.shield,
                    label: 'Privacy & Security',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: AppIconsSvg.info,
                    label: 'Notifications',
                    onTap: () {},
                  ),
                  Spacing.y(2),
                  _SectionLabel('Subscription', textTheme, colors),
                  _MenuItem(
                    icon: AppIconsSvg.magic,
                    label: 'Upgrade to Pro',
                    onTap: () =>
                        NavigationService.pushNamed(AppRoutes.subscription),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'PRO',
                        style: textTheme.bodySmall?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ),
                  _MenuItem(
                    icon: AppIconsSvg.info2,
                    label: 'Manage Subscription',
                    onTap: () {},
                  ),
                  Spacing.y(2),
                  _SectionLabel('Support', textTheme, colors),
                  _MenuItem(
                    icon: AppIconsSvg.info,
                    label: 'Help & FAQ',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: AppIconsSvg.send,
                    label: 'Contact Us',
                    onTap: () {},
                  ),
                  Spacing.y(2),
                  // Sign out
                  _MenuItem(
                    icon: AppIconsSvg.arrowBack,
                    label: 'Sign Out',
                    onTap: () {},
                    labelColor: colors.error,
                    iconColor: colors.error,
                  ),
                  Spacing.y(3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stat card ─────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final String icon;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
          boxShadow: [AppConstants.defaultShadow],
        ),
        child: Column(
          children: [
            CustomSvg(path: icon, size: 20, color: scheme.primary),
            Spacing.y(0.8),
            Text(
              value,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(color: colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  final TextTheme textTheme;
  final AppColorsExtension colors;

  const _SectionLabel(this.text, this.textTheme, this.colors);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: textTheme.bodySmall?.copyWith(
            color: colors.grey,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

// ── Menu item ─────────────────────────────────────────────────────────────────
class _MenuItem extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;
  final Color? labelColor;
  final Color? iconColor;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.labelColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
          boxShadow: [AppConstants.defaultShadow],
        ),
        child: Row(
          children: [
            CustomSvg(
              path: icon,
              size: 20,
              color: iconColor ?? colors.iconColor,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                label,
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: labelColor,
                ),
              ),
            ),
            trailing ??
                CustomSvg(
                  path: AppIconsSvg.arrowForward,
                  size: 16,
                  color: colors.grey,
                ),
          ],
        ),
      ),
    );
  }
}
