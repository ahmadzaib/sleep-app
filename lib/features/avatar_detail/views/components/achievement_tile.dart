import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AchievementTile extends StatelessWidget {
  final String title;
  final String subtitle;
  const AchievementTile({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      width: 10.sw,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: .75),
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius + 2),
        boxShadow: [AppConstants.defaultShadow],
      ),
      child: Row(
        children: [
          Image.asset(AppImagesPng.milestoneCheck2, width: 40.w),
          Spacing.x(2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Title
                Text(
                  title,
                  style: theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
                Spacing.y(.5),

                Text(subtitle, style: theme.textTheme.bodySmall!.copyWith()),
              ],
            ),
          ),
          Spacing.x(2),
          CustomSvg(path: AppIconsSvg.arrowForward),
        ],
      ),
    );
  }
}
