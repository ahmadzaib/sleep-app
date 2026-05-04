import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WaveformWidget extends StatelessWidget {
  const WaveformWidget({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final baseColor = isActive
        ? context.appColors.primary
        : context.appColors.grey.withValues(alpha: 0.45);

    return Row(
      children: List.generate(
        14,
        (index) => Container(
          margin: EdgeInsets.only(right: 3.w),
          width: 3.w,
          height: ((index % 4) + 2) * 4.h,
          decoration: BoxDecoration(
            color: baseColor.withValues(
              alpha: isActive ? (0.45 + (index % 4) * 0.12) : 1,
            ),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ),
    );
  }
}
