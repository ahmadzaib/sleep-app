import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/avatar_detail/views/components/achievement_tile.dart';
import 'package:avatar_flow/features/avatar_detail/views/components/avatar_section.dart';
import 'package:avatar_flow/features/avatar_detail/views/components/detail_screen_appbar.dart';
import 'package:avatar_flow/widgets/bg_widget.dart';
import 'package:avatar_flow/widgets/custom_divider.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvatarDetailScreen extends StatelessWidget {
  const AvatarDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height * 0.01;
    final sw = MediaQuery.of(context).size.width * 0.01;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AvatarDetailAppbar(
          title: "Avatar",
          subtitleText: "Meet and manage your character",
          onInfoTap: () {},
          actions: [
            IconButton(
              style: IconButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {},
              icon: CustomSvg(path: AppIconsSvg.moreVer),
            ),
          ],
        ),

        body: Padding(
          padding: AppConstants.defaultPaddingHorizental,
          child: SingleChildScrollView(
            child: Column(
              children: [
                AvatarSection(),
                Spacing.y(2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8.w,
                  children: [
                    _buildChip("10 Stories", AppIconsSvg.book, context),
                    _buildChip("10 Shares", AppIconsSvg.upload, context),
                    _buildChip("Female", AppIconsSvg.woman, context),
                  ],
                ),
                Spacing.y(2),
                SizedBox(
                  height: 12 * sh,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8.w,
                    children: [
                      _buildSkillChip(
                        "Adventurous",
                        AppImagesPng.adventurous,
                        context,
                      ),
                      _buildSkillChip("Fearful", AppImagesPng.poison, context),
                      _buildSkillChip("Brave", AppImagesPng.gold, context),
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
                      onPressed: () {},
                      child: Text(
                        'View all',
                        style: textTheme.bodyMedium!.copyWith(
                          color: context.appColors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  Widget _buildSkillChip(String text, String imagePath, BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
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
            Image.asset(imagePath, height: 32),
            Spacing.y(.6),
            Text(text, style: textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
