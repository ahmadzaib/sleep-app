import 'dart:ui';

import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/router/routes.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/avatar/models/shared_avatar_model.dart';
import 'package:avatar_flow/features/avatar/providers/avatars_provider.dart';
import 'package:avatar_flow/widgets/app_loading.dart';
import 'package:avatar_flow/widgets/circled_icon_widget.dart';
import 'package:avatar_flow/widgets/confirmation_dialog.dart';
import 'package:avatar_flow/widgets/custom_cache_netword_imge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class SharedAvatarsView extends StatefulWidget {
  const SharedAvatarsView({super.key});

  @override
  State<SharedAvatarsView> createState() => _SharedAvatarsViewState();
}

class _SharedAvatarsViewState extends State<SharedAvatarsView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.72);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AvatarsProvider>().fetchSharedAvatars();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AvatarsProvider>(
      builder: (context, provider, _) {
        return Column(children: [Spacing.y(2), _buildBody(context, provider)]);
      },
    );
  }

  Widget _buildBody(BuildContext context, AvatarsProvider provider) {
    final theme = Theme.of(context);

    if (provider.isLoadingShared) {
      return _buildShimmer(theme);
    }

    if (provider.sharedError != null && provider.sharedAvatars.isEmpty) {
      return SizedBox(
        height: 340.h,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 40.r,
                color: theme.colorScheme.error,
              ),
              Spacing.y(1),
              Text(
                'Failed to load shared avatars',
                style: theme.textTheme.bodyMedium,
              ),
              Spacing.y(1),
              TextButton(
                onPressed: () =>
                    context.read<AvatarsProvider>().fetchSharedAvatars(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.sharedAvatars.isEmpty) {
      return SizedBox(
        height: 340.h,
        child: Center(
          child: Text(
            'No avatars shared with you yet.',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return SizedBox(
      height: 370.h,
      child: ClipRRect(
        child: PageView.builder(
          controller: _pageController,
          itemCount: provider.sharedAvatars.length,
          padEnds: false,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final shared = provider.sharedAvatars[index];
            return AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                double page = 0;
                if (_pageController.hasClients &&
                    _pageController.page != null) {
                  page = _pageController.page!;
                }
                final distance = (page - index).abs().clamp(0.0, 1.0);
                final scale = lerpDouble(1.0, 0.85, distance)!;
                final hPadding = lerpDouble(
                  AppConstants.paddingOnly,
                  0.w,
                  distance,
                )!;

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: hPadding),
                  child: Transform.scale(
                    scale: scale,
                    alignment: Alignment.centerLeft,
                    child: _buildSharedCard(context, shared, provider),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSharedCard(
    BuildContext context,
    SharedAvatarModel shared,
    AvatarsProvider provider,
  ) {
    final theme = Theme.of(context);
    final avatar = shared.avatar;
    final name = avatar?.name ?? 'Unknown';
    final avatarUrl = avatar?.avatarUrl ?? '';
    final traitsText = (avatar?.traits.isNotEmpty ?? false)
        ? avatar!.traits.take(2).map((t) => t.name).join(', ')
        : (avatar?.gender ?? '');

    return Column(
      children: [
        Expanded(
          child: ZoomTapAnimation(
            onTap: () {
              if (shared.avatar != null) {
                NavigationService.pushNamed(
                  AppRoutes.avatarDetail,
                  extra: {'avatar': shared.avatar, 'isShared': true},
                );
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppConstants.largeRadius),
                boxShadow: [AppConstants.defaultShadow],
              ),
              child: Stack(
                children: [
                  // Coloured bottom section
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: AppConstants.defaultAllPadding,
                      child: Container(
                        width: 1.sw,
                        height: 0.15.sh,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(
                            AppConstants.smallRadius,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Spacing.y(2),
                      Expanded(
                        child: Center(
                          child: avatarUrl.isNotEmpty
                              ? CustomCachedNetworkImage(
                                  imageUrl: avatarUrl,
                                  height: 200.h,
                                  width: 0.5.sw,
                                  borderRadius: AppConstants.smallRadius,
                                  cover: BoxFit.cover,
                                )
                              : Image.asset(AppImagesPng.dummyImage),
                        ),
                      ),
                      Spacing.y(1),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: Column(
                          children: [
                            Text(
                              name,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontSize: 18.sp,
                              ),
                            ),
                            Spacing.y(.5),
                            Text(
                              traitsText,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Shared badge
                  Positioned(
                    top: 10.h,
                    left: 10.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.15,
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 12.r,
                            color: theme.colorScheme.primary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Shared',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Remove button
        provider.isRemoving
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: SizedBox(height: 20.h, width: 20.h, child: AppLoading()),
              )
            : TextButton(
                onPressed: () => _confirmRemove(context, shared, provider),
                child: Text(
                  'Remove',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
      ],
    );
  }

  void _confirmRemove(
    BuildContext context,
    SharedAvatarModel shared,
    AvatarsProvider provider,
  ) {
    ConfirmationDialog.show(
      content: CircledIconWidget(
        color: context.appColors.error,
        icon: Icons.warning,
      ),
      context: context,
      title: 'Remove Avatar',
      subtitle: 'Are you sure you want to remove this shared avatar?',
      confirmText: 'Remove',
      cancelText: 'Cancel',
      onConfirm: () => provider.removeSharedAvatar(shared.id),
    );
  }

  Widget _buildShimmer(ThemeData theme) {
    return SizedBox(
      height: 340.h,
      child: Shimmer.fromColors(
        baseColor: context.appColors.lightGrey,
        highlightColor: context.appColors.bubbleGray,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
              width: 0.6.sw,
              margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppConstants.largeRadius),
              ),
            );
          },
        ),
      ),
    );
  }
}
