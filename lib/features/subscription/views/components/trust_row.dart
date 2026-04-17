import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubscriptionTrustRow extends StatelessWidget {
  final String svgPath;
  final String text;
  final Color? iconColor;
  final Widget? trailing;

  const SubscriptionTrustRow({
    super.key,
    required this.svgPath,
    required this.text,
    this.iconColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSvg(
          path: svgPath,
          size: 18.sp,
          color: iconColor ?? colors.primary,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            text,
            style: textTheme.bodySmall?.copyWith(color: colors.grey),
          ),
        ),
        if (trailing != null) ...[SizedBox(width: 6.w), trailing!],
      ],
    );
  }
}
