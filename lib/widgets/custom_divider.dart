import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4.h,
      width: 10.sw,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            context.appColors.primary.withValues(alpha: .3),
            context.appColors.primary,
            context.appColors.primary.withValues(alpha: .3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
