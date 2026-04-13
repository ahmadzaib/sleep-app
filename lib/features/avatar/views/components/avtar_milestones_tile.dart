import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvtarMilestonesTile extends StatelessWidget {
  final String title;
  final int totalValue;
  final int completedValue;

  const AvtarMilestonesTile({
    super.key,
    required this.title,
    required this.totalValue,
    required this.completedValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      margin: AppConstants.defaultPaddingHorizental,
      height: 75.h,
      width: 10.sw,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius + 2),
        boxShadow: [AppConstants.defaultShadow],
      ),
      child: Row(
        children: [
          Image.asset(AppImagesPng.milestoneCheck),
          Spacing.x(2),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Title and counter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(title, style: theme.textTheme.bodyLarge),
                    Text(
                      "${completedValue.toString()}/${totalValue.toString()}",
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: .5,
                        ),
                      ),
                    ),
                  ],
                ),
                //PROGRESS BAR
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [
                        theme.colorScheme.secondary,
                        theme.colorScheme.primary,
                        theme.colorScheme.primary,
                      ],
                    ).createShader(bounds);
                  },
                  child: LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(10),
                    value: completedValue / 10,
                    backgroundColor: theme.colorScheme.onSurface.withValues(
                      alpha: .1,
                    ),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.surface,
                    ),
                  ),
                ),

                //
                Text(
                  "Unlock exclusive rewards and themes!",
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: .5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
