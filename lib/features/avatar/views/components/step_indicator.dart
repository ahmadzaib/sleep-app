import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StepIndicator extends StatelessWidget {
  const StepIndicator({super.key, required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    const labels = ['Agreement', 'Record', 'Character'];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: List.generate(labels.length, (index) {
          final isActive = index == currentStep;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: AppConstants.defaultDuration,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: isActive
                          ? context.appColors.secondary
                          : context.appColors.lightGrey,
                      borderRadius: BorderRadius.circular(
                        AppConstants.extraLargeRadius,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
