import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  // prefix icon support
  final Widget? prefixIcon;
  final double iconSpacing;

  const CustomTextButton({
    super.key,
    this.onPressed,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.borderRadius,
    this.prefixIcon,
    this.iconSpacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor:
            backgroundColor ?? context.appColors.primary.withValues(alpha: .15),
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (prefixIcon != null) ...[
            prefixIcon!,
            SizedBox(width: iconSpacing),
          ],
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: textColor ?? context.appColors.primary,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}
