import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VoiceNoteTile extends StatelessWidget {
  const VoiceNoteTile({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: AppConstants.defaultAllPadding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [AppConstants.defaultShadow],
      ),
      child: Row(
        children: [
          CustomSvg(
            path: AppIconsSvg.speech,
            color: context.appColors.grey,
            size: 20,
          ),
          Spacing.x(3),
          Text("Voice Note 1", style: textTheme.bodyMedium),
          const Spacer(),
          // Simple Waveform Representation
          Row(
            children: List.generate(
              10,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 1.w),
                width: 2.w,
                height: (index % 3 + 1) * 4.h,
                decoration: BoxDecoration(
                  color: context.appColors.grey.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
          ),
          Spacing.x(3),
          Icon(Icons.play_arrow, color: context.appColors.grey, size: 20),
        ],
      ),
    );
  }
}
