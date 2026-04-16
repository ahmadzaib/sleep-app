import 'package:avatar_flow/core/utils/haptic_helper.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:avatar_flow/widgets/app_loading.dart';
import 'package:svg_flutter/svg.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? textColor;
  final Color? buttonColor;
  final double? buttonBorderRadius;
  final bool isDisabled;
  final bool isOutlineButton;
  final double height;
  final double? textFontSize;
  final String? prefixIcon;
  final bool isLoading;
  final Color? preffixIconColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 46,
    this.textColor,
    this.buttonColor,
    this.buttonBorderRadius,
    this.isDisabled = false,
    this.isOutlineButton = false,
    this.prefixIcon,
    this.textFontSize,
    this.isLoading = false,
    this.preffixIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: (isDisabled)
          ? null
          : () {
              HapticHelper.mediumImpact();
              onPressed?.call();
            },
      child: Container(
        alignment: Alignment.center,
        height: height.h,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isOutlineButton
              ? Colors.transparent
              : (isDisabled)
              ? context.appColors.grey
              : buttonColor ?? context.appColors.secondary,
          borderRadius: BorderRadius.circular(buttonBorderRadius ?? 30.r),
          border: Border.all(
            color: isOutlineButton
                ? buttonColor ?? context.appColors.lightGrey
                : Colors.transparent,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.h,
                child: AppLoading(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prefixIcon != null) ...[
                    SvgPicture.asset(
                      prefixIcon!,
                      colorFilter: ColorFilter.mode(
                        preffixIconColor ??
                            textColor ??
                            Theme.of(context).iconTheme.color!,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 8.w),
                  ],
                  Text(
                    text,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: isOutlineButton
                          ? textColor
                          : textColor ??
                                Theme.of(context).colorScheme.onPrimary,
                      fontSize: textFontSize ?? 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
