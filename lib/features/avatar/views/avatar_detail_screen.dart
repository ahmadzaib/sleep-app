import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/router/routes.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/avatar/models/avatar_model.dart';
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
import 'package:super_tooltip/super_tooltip.dart';

class AvatarDetailScreen extends StatefulWidget {
  final AvatarModel avatar;
  const AvatarDetailScreen({super.key, required this.avatar});

  @override
  State<AvatarDetailScreen> createState() => _AvatarDetailScreenState();
}

class _AvatarDetailScreenState extends State<AvatarDetailScreen> {
  final _infoTooltipCont = SuperTooltipController();
  final _skillsTooltipCont = SuperTooltipController();
  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height * 0.01;
    final textTheme = Theme.of(context).textTheme;

    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppbar(),

        body: Padding(
          padding: AppConstants.defaultPaddingHorizental,
          child: SingleChildScrollView(
            child: Column(
              children: [
                AvatarSection(avatarModel: widget.avatar),
                Spacing.y(2),

                CustomToolTip(
                  tooltipController: _skillsTooltipCont,
                  text: "Sword Master: Skilled in combat techniques.",
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8.w,
                    children: [
                      _buildChip(
                        "${widget.avatar.storiesCount} Stories",
                        AppIconsSvg.book,
                        context,
                      ),
                      _buildChip(
                        "${widget.avatar.shareCount} Shares",
                        AppIconsSvg.upload,
                        context,
                      ),
                      _buildChip(
                        widget.avatar.gender,
                        getGenderIcon(widget.avatar.gender),
                        context,
                      ),
                    ],
                  ),
                ),
                Spacing.y(2),
                SizedBox(
                  height: 12 * sh,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8.w,
                    children: [
                      ...widget.avatar.traits.take(3).map((trait) {
                        return _buildSkillChip(
                          trait.name,
                          trait.imageUrl,
                          context,
                        );
                      }),
                    ],
                  ),
                ),
                Spacing.y(2),
                CustomDivider(),
                Spacing.y(3),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Achievement", style: textTheme.bodyMedium),
                ),
                Spacing.y(1),
                AchievementTile(
                  title: "Hero of the Magical Forest",
                  subtitle: "100 Stories Shared",
                ),
                Spacing.y(1),
                //Stories where it appears
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Stories where it appears',
                      style: textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        NavigationService.pushNamed(AppRoutes.allStories);
                      },
                      child: Text(
                        'View all',
                        style: textTheme.bodyMedium!.copyWith(
                          color: context.appColors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                StoryCards(),
                Spacing.y(2),
                SharedWithUsersSection(),
                Spacing.y(2),
                CustomButton(text: "Start an Adventure", onPressed: () {}),

                //
                Spacing.y(2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar() {
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

          onPressed: () {
            _infoTooltipCont.showTooltip();
          },

          icon: CustomSvg(path: AppIconsSvg.info2, size: 16),
        ),
        onClose: () {
          _skillsTooltipCont.showTooltip();
        },
      ),

      actions: [
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
                break;
              case 'delete':
                _deleteAvatar();
                break;
            }
          },
        ),
      ],
    );
  }

  _deleteAvatar() {
    ConfirmationDialog.show(
      content: CircledIconWidget(
        color: context.appColors.error,
        icon: Icons.delete,
      ),
      context: context,
      title: "Delete Avatar",
      subtitle: "Are you sure, You want to delete this avatar?",
      confirmText: "Delete",
      cancelText: "Cancel",
      onConfirm: () async {
        if (widget.avatar.id != null) {
          await context.read<AvatarsProvider>().deleteAvatar(widget.avatar.id!);
        }
      },
    );
  }

  String getGenderIcon(String gender) {
    switch (gender) {
      case "Male":
        return AppIconsSvg.man;
      case "Female":
        return AppIconsSvg.woman;
      default:
        return AppIconsSvg.intersex;
    }
  }

  Widget _buildChip(String text, String svgPath, BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(color: colorScheme.onSurface.withValues(alpha: .2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomSvg(path: svgPath, size: 16, color: colorScheme.onSurface),
          Spacing.x(1),
          Text(text, style: textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String text, String? imageUrl, BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
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
            Text(text, style: textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
