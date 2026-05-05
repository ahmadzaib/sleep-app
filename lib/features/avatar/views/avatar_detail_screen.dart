import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/router/routes.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/premium_animation.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/avatar/models/avatar_model.dart';
import 'package:avatar_flow/features/avatar/providers/avatar_detail_provider.dart';
import 'package:avatar_flow/features/avatar/providers/create_avatar_provider.dart';
import 'package:avatar_flow/features/avatar/providers/avatars_provider.dart';
import 'package:avatar_flow/features/avatar/views/components/achievement_tile.dart';
import 'package:avatar_flow/features/avatar/views/avatar_section.dart';
import 'package:avatar_flow/features/avatar/views/components/detail_screen_appbar.dart';
import 'package:avatar_flow/features/avatar/views/shared_with_users_section.dart';
import 'package:avatar_flow/features/avatar/views/components/story_cards_carousal.dart';
import 'package:avatar_flow/features/avatar/views/components/tool_tip_widget.dart';
import 'package:avatar_flow/widgets/bg_widget.dart';
import 'package:avatar_flow/widgets/circled_icon_widget.dart';
import 'package:avatar_flow/widgets/confirmation_dialog.dart';
import 'package:avatar_flow/widgets/custom_button.dart';
import 'package:avatar_flow/widgets/custom_cache_netword_imge.dart';
import 'package:avatar_flow/widgets/custom_divider.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:avatar_flow/widgets/pop_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:super_tooltip/super_tooltip.dart';

/// Entry point — scopes [AvatarDetailProvider] to this screen only
class AvatarDetailScreen extends StatelessWidget {
  final AvatarModel avatar;
  final bool isShared;

  const AvatarDetailScreen({
    super.key,
    required this.avatar,
    this.isShared = false,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AvatarDetailProvider(),
      child: _AvatarDetailView(avatar: avatar, isShared: isShared),
    );
  }
}

// ── Main view ─────────────────────────────────────────────────────────────────
class _AvatarDetailView extends StatefulWidget {
  final AvatarModel avatar;
  final bool isShared;

  const _AvatarDetailView({required this.avatar, required this.isShared});

  @override
  State<_AvatarDetailView> createState() => _AvatarDetailViewState();
}

class _AvatarDetailViewState extends State<_AvatarDetailView> {
  final _infoTooltipCont = SuperTooltipController();
  final _skillsTooltipCont = SuperTooltipController();

  @override
  void initState() {
    super.initState();
    if (widget.isShared) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AvatarDetailProvider>().loadCreator(widget.avatar);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height * 0.01;
    final textTheme = Theme.of(context).textTheme;

    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppbar(context),
        body: Padding(
          padding: AppConstants.defaultPaddingHorizental,
          child: SingleChildScrollView(
            child: Column(
              children: [
                PremiumAnimation.scaleIn(
                  beginScale: 0.93,
                  duration: const Duration(milliseconds: 500),
                  child: AvatarSection(
                    avatarModel: widget.avatar,
                    isShared: widget.isShared,
                  ),
                ),
                Spacing.y(2),

                PremiumAnimation.fadeInUp(
                  delay: const Duration(milliseconds: 120),
                  child: CustomToolTip(
                    tooltipController: _skillsTooltipCont,
                    text: "Sword Master: Skilled in combat techniques.",
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 8.w,
                      children: [
                        if (!widget.isShared) ...[
                          _chip(
                            "${widget.avatar.storiesCount} Stories",
                            AppIconsSvg.book,
                          ),
                          _chip(
                            "${widget.avatar.shareCount} Shares",
                            AppIconsSvg.upload,
                          ),
                        ],
                        _chip(
                          widget.avatar.gender,
                          _genderIcon(widget.avatar.gender),
                        ),
                      ],
                    ),
                  ),
                ),

                if (widget.isShared) ...[
                  Spacing.y(1),
                  PremiumAnimation.fadeInUp(
                    delay: const Duration(milliseconds: 160),
                    child: const _CreatorSection(),
                  ),
                ],
                Spacing.y(2),

                PremiumAnimation.fadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: SizedBox(
                    height: 12 * sh,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 8.w,
                      children: widget.avatar.traits
                          .take(3)
                          .map((t) => _skillChip(t.name, t.imageUrl))
                          .toList(),
                    ),
                  ),
                ),
                Spacing.y(2),

                PremiumAnimation.fadeInUp(
                  delay: const Duration(milliseconds: 260),
                  child: CustomDivider(),
                ),
                Spacing.y(3),

                PremiumAnimation.fadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Achievement", style: textTheme.bodyMedium),
                      ),
                      Spacing.y(1),
                      AchievementTile(
                        title: "Hero of the Magical Forest",
                        subtitle: "100 Stories Shared",
                      ),
                    ],
                  ),
                ),
                Spacing.y(1),

                PremiumAnimation.fadeInUp(
                  delay: const Duration(milliseconds: 360),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Stories where it appears',
                            style: textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: () => NavigationService.pushNamed(
                              AppRoutes.allStories,
                              extra: {'avatarId': widget.avatar.id},
                            ),
                            child: Text(
                              'View all',
                              style: textTheme.bodyMedium!.copyWith(
                                color: context.appColors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      StoryCards(avatarId: widget.avatar.id!),
                    ],
                  ),
                ),

                if (!widget.isShared) ...[
                  Spacing.y(2),
                  PremiumAnimation.fadeInUp(
                    delay: const Duration(milliseconds: 420),
                    child: SharedWithUsersSection(avatarId: widget.avatar.id!),
                  ),
                ],
                Spacing.y(2),

                PremiumAnimation.fadeInUp(
                  delay: const Duration(milliseconds: 460),
                  child: CustomButton(
                    text: "Start an Adventure",
                    onPressed: () {},
                  ),
                ),
                Spacing.y(2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AvatarDetailAppbar(
      title: "Avatar",
      subtitleText: "Meet and manage your character",
      widgetWithTitle: CustomToolTip(
        tooltipController: _infoTooltipCont,
        text:
            "Share ${widget.avatar.name}'s profile with friends or in the community.",
        child: IconButton(
          style: IconButton.styleFrom(
            alignment: Alignment.center,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: _infoTooltipCont.showTooltip,
          icon: CustomSvg(path: AppIconsSvg.info2, size: 16),
        ),
        onClose: _skillsTooltipCont.showTooltip,
      ),
      actions: widget.isShared
          ? []
          : [
              ReusablePopupMenu(
                iconPath: AppIconsSvg.moreVer,
                items: const [
                  MenuItemConfig(
                    value: 'edit',
                    iconPath: AppIconsSvg.edit,
                    label: 'Edit Avatar',
                  ),
                  MenuItemConfig(
                    value: 'delete',
                    iconPath: AppIconsSvg.delete,
                    label: 'Delete Avatar',
                  ),
                ],
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      context.read<CreateAvatarProvider>().loadAvatarForEdit(
                        widget.avatar,
                      );
                      NavigationService.pushNamed(
                        AppRoutes.createAvatar,
                        extra: true,
                      );
                    case 'delete':
                      ConfirmationDialog.show(
                        content: CircledIconWidget(
                          color: context.appColors.error,
                          icon: Icons.delete,
                        ),
                        context: context,
                        title: "Delete Avatar",
                        subtitle:
                            "Are you sure you want to delete this avatar?",
                        confirmText: "Delete",
                        cancelText: "Cancel",
                        onConfirm: () async {
                          if (widget.avatar.id != null) {
                            await context.read<AvatarsProvider>().deleteAvatar(
                              widget.avatar.id!,
                            );
                          }
                        },
                      );
                  }
                },
              ),
            ],
    );
  }

  String _genderIcon(String gender) {
    switch (gender) {
      case "Male":
        return AppIconsSvg.man;
      case "Female":
        return AppIconsSvg.woman;
      default:
        return AppIconsSvg.intersex;
    }
  }

  Widget _chip(String text, String svgPath) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(color: colorScheme.onSurface.withValues(alpha: .2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomSvg(path: svgPath, size: 16, color: colorScheme.onSurface),
          Spacing.x(1),
          Text(text, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _skillChip(String text, String? imageUrl) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
          border: Border.all(
            color: colorScheme.onSurface.withValues(alpha: .2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageUrl != null && imageUrl.isNotEmpty)
              CustomCachedNetworkImage(
                imageUrl: imageUrl,
                height: 40,
                width: 40,
                borderRadius: AppConstants.smallRadius,
              )
            else
              Icon(Icons.star, size: 32, color: colorScheme.primary),
            Spacing.y(.6),
            Text(text, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

// ── Creator section — pure Consumer, zero setState ────────────────────────────
class _CreatorSection extends StatelessWidget {
  const _CreatorSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<AvatarDetailProvider>(
      builder: (context, provider, _) {
        final name = provider.creator?.name ?? '';
        final imageUrl = provider.creator?.avatarUrl;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomCachedNetworkImage(
              imageUrl: imageUrl,
              height: 24.r,
              width: 24.r,
              borderRadius: 40.r,
              cover: BoxFit.cover,
            ),
            SizedBox(width: 10.w),
            if (provider.isLoading)
              SizedBox(
                width: 80.w,
                height: 14.h,
                child: Shimmer.fromColors(
                  baseColor: context.appColors.lightGrey,
                  highlightColor: context.appColors.bubbleGray,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              )
            else if (name.isNotEmpty)
              Text(
                name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
          ],
        );
      },
    );
  }
}
