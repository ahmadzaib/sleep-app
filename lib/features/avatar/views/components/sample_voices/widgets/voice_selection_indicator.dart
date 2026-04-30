import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VoiceSelectionIndicator extends StatelessWidget {
  const VoiceSelectionIndicator({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppConstants.defaultDuration,
      width: 22.w,
      height: 22.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? context.appColors.primary
              : context.appColors.grey.withValues(alpha: 0.5),
          width: 1.6,
        ),
      ),
      child: Center(
        child: AnimatedContainer(
          duration: AppConstants.defaultDuration,
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? context.appColors.primary : Colors.transparent,
          ),
        ),
      ),
    );
  }
}
