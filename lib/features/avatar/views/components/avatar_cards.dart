import 'dart:ui';
import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/debug/debug_point.dart';
import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/router/routes.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/avatar/models/avatar_model.dart';
import 'package:avatar_flow/features/avatar/providers/avatars_provider.dart';
import 'package:avatar_flow/features/avatar/views/avatar_section.dart';
import 'package:avatar_flow/widgets/custom_cache_netword_imge.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class AvatarCards extends StatefulWidget {
  final bool? showRemoveButton;
  final VoidCallback? onRemoveTap;
  const AvatarCards({super.key, this.showRemoveButton, this.onRemoveTap});

  @override
  State<AvatarCards> createState() => _AvatarCardsState();
}

class _AvatarCardsState extends State<AvatarCards> {
  late PageController _pageController;
  // Colors computed once per avatar list — keyed by avatar id

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.72);
    // Fetch avatars on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AvatarsProvider>().fetchAvatars();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<AvatarsProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return _buildShimmerCards(theme);
        }

        if (provider.error != null && provider.avatars.isEmpty) {
          return SizedBox(
            height: 340.h,
            child: Center(
              child: Text(
                'Failed to load avatars',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          );
        }

        if (provider.avatars.isEmpty) {
          return SizedBox(
            height: 340.h,
            child: Center(
              child: Text(
                'No avatars yet. Create one!',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          );
        }

        return SizedBox(
          height: 340.h,
          child: ClipRRect(
            child: PageView.builder(
              controller: _pageController,
              itemCount: provider.avatars.length,
              padEnds: false,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final avatar = provider.avatars[index];
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double page = 0;
                    if (_pageController.hasClients &&
                        _pageController.page != null) {
                      page = _pageController.page!;
                    }

                    double distance = (page - index).abs().clamp(0.0, 1.0);

                    double scale = lerpDouble(1.0, 0.85, distance)!;

                    double hPadding = lerpDouble(
                      AppConstants.paddingOnly,
                      0.w,
                      distance,
                    )!;

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: hPadding),
                      child: Transform.scale(
                        scale: scale,
                        alignment: Alignment.centerLeft,
                        child: _buildCard(
                          avatar,
                          theme,
                          () {
                            NavigationService.pushNamed(
                              AppRoutes.avatarDetail,
                              extra: {'avatar': avatar},
                            );
                          },
                          widget.showRemoveButton ?? false,
                          widget.onRemoveTap ?? () {},
                          _getAvatarColor(avatar),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerCards(ThemeData theme) {
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

  Widget _buildCard(
    AvatarModel avatar,
    ThemeData theme,
    VoidCallback onTap,
    bool showRemoveButton,
    VoidCallback onRemoveTap,
    Color cardColor,
  ) {
    final traitsText = avatar.traits.isNotEmpty
        ? avatar.traits.take(2).map((trait) => trait.name).join(', ')
        : avatar.gender;

    return Column(
      children: [
        Expanded(
          child: ZoomTapAnimation(
            onTap: onTap,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppConstants.largeRadius),
                boxShadow: [AppConstants.defaultShadow],
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: AppConstants.defaultAllPadding,
                      child: ClipPath(
                        clipper: MyClipper(),
                        child: Container(
                          width: 1.sw,
                          height: 0.21.sh,
                          color: cardColor,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Spacing.y(2),
                      Expanded(
                        child: Center(
                          child: avatar.avatarUrl.isNotEmpty
                              ? CustomCachedNetworkImage(
                                  imageUrl: avatar.avatarUrl,
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
                              avatar.name,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontSize: 18.sp,
                              ),
                            ),
                            Spacing.y(.5),
                            Text(
                              traitsText,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: .5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {},
                      icon: CustomSvg(path: AppIconsSvg.info2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showRemoveButton)
          TextButton(
            onPressed: onRemoveTap,
            child: Text(
              "Remove",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }

  /// Get avatar background color from hex string or fallback to red
  Color _getAvatarColor(AvatarModel avatar) {
    if (avatar.color != null && avatar.color!.isNotEmpty) {
      try {
        final hex = avatar.color!.replaceFirst('#', '');
        return Color(int.parse('FF$hex', radix: 16)).withValues(alpha: 0.3);
      } catch (e) {
        DebugPoint.error('Failed to parse avatar color: ${avatar.color}');
      }
    }
    return Colors.red.withValues(alpha: 0.3);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
