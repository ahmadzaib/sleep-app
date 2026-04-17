import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContinueFreePlanButton extends StatelessWidget {
  const ContinueFreePlanButton({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Column(
        children: [
          Text(
            'Continue with the free plan',
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Limited access to basic stories and tools.',
            style: textTheme.bodySmall?.copyWith(color: colors.grey),
          ),
        ],
      ),
    );
  }
}
