import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/constants/keys.dart';
import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/router/routes.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/auth/providers/auth_provider.dart';
import 'package:avatar_flow/features/profile/views/components/profile_header.dart';
import 'package:avatar_flow/features/profile/views/components/profile_menu_section.dart';
import 'package:avatar_flow/features/profile/views/components/profile_stats.dart';
import 'package:avatar_flow/widgets/bg_widget.dart';
import 'package:avatar_flow/widgets/confirmation_dialog.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Profile',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: CustomSvg(
              path: AppIconsSvg.arrowBack,
              size: 20,
              color: colors.iconColor,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: CustomSvg(
                path: AppIconsSvg.info,
                size: 22,
                color: colors.iconColor,
              ),
            ),
            SizedBox(width: 8.w),
          ],
        ),
        body: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            final userInfo = authProvider.userInfo;
            final userName = userInfo.name ?? userInfo.email.split('@').first;
            final userEmail = userInfo.email;
            final avatarUrl = userInfo.avatarUrl ?? Keys.placeHolderImage;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  ProfileHeader(
                    name: userName,
                    email: userEmail,
                    imageUrl: avatarUrl,
                    plan: 'Free Plan',
                  ),
                  const ProfileStats(
                    avatarsCount: 12,
                    storiesCount: 48,
                    rating: 4.5,
                  ),
                  Spacing.y(2),
                  ProfileMenuSection(
                    title: 'Account Settings',
                    items: [
                      ProfileMenuItemModel(
                        icon: AppIconsSvg.edit,
                        label: 'Edit Profile',
                        onTap: () {},
                      ),
                      ProfileMenuItemModel(
                        icon: AppIconsSvg.shield,
                        label: 'Privacy & Security',
                        onTap: () {},
                      ),
                      ProfileMenuItemModel(
                        icon: AppIconsSvg.info,
                        label: 'Notifications',
                        onTap: () {},
                      ),
                    ],
                  ),
                  ProfileMenuSection(
                    title: 'Subscription',
                    items: [
                      ProfileMenuItemModel(
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
                            gradient: LinearGradient(
                              colors: [scheme.primary, scheme.tertiary],
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            'PRO',
                            style: textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      ProfileMenuItemModel(
                        icon: AppIconsSvg.info2,
                        label: 'Manage Subscription',
                        onTap: () {},
                      ),
                    ],
                  ),
                  ProfileMenuSection(
                    title: 'More',
                    items: [
                      ProfileMenuItemModel(
                        icon: AppIconsSvg.info,
                        label: 'Help & FAQ',
                        onTap: () {},
                      ),
                      ProfileMenuItemModel(
                        icon: AppIconsSvg.send,
                        label: 'Contact Us',
                        onTap: () {},
                      ),
                      ProfileMenuItemModel(
                        icon: AppIconsSvg.arrowBack,
                        label: 'Sign Out',
                        onTap: () {
                          ConfirmationDialog.show(
                            context: context,
                            title: 'Sign Out',
                            subtitle: 'Are you sure you want to sign out?',
                            onConfirm: () {
                              context.read<AuthProvider>().signOut();
                            },
                          );
                        },
                        color: colors.error,
                      ),
                    ],
                  ),
                  Spacing.y(4),
                  Text(
                    'v 1.0.24 (2026)',
                    style: textTheme.labelSmall?.copyWith(
                      color: colors.grey.withValues(alpha: 0.5),
                      letterSpacing: 1.1,
                    ),
                  ),
                  Spacing.y(4),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
