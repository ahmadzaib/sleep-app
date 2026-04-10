import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show TextInputFormatter;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? title;
  final bool isRequired;
  final String? errorText;
  final String? initialValue;
  final bool isReadOnly;
  final FocusNode? focusNode;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final int? maxLines;
  final int? maxLength;
  final double? textfieldBorderRadius;
  final bool? isEnabled;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? obscureText;
  final bool? isFilled;
  final bool isEditProfile;
  final Color? fillColor;
  final AutovalidateMode? autoValidateMode;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final Color? borderColor;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  const CustomTextField({
    super.key,
    this.title,
    this.isRequired = false,
    this.isEditProfile = false,
    this.hintText,
    this.borderColor,
    this.isEnabled,
    this.errorText,
    this.onTap,
    this.autoValidateMode,
    this.onChanged,
    this.textfieldBorderRadius,
    this.isReadOnly = false,
    this.focusNode,
    this.maxLines = 1,
    this.obscureText,
    this.initialValue,
    this.textInputType,
    this.prefixIcon,
    this.validator,
    this.maxLength,
    this.isFilled = true,
    this.fillColor,
    this.inputFormatters,
    this.controller,
    this.suffixIcon,
    this.textInputAction,
    this.onFieldSubmitted,
    this.contentPadding,
  });
  @override
  Widget build(BuildContext context) {
    final double radius = textfieldBorderRadius ?? AppConstants.largeRadius;

    /// Border
    final OutlineInputBorder border = OutlineInputBorder(
      borderSide: BorderSide(color: borderColor ?? context.appColors.lightGrey),
      borderRadius: BorderRadius.circular(radius),
    );
    final OutlineInputBorder activeBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
      borderRadius: BorderRadius.circular(radius),
    );
    final OutlineInputBorder errorBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
      borderRadius: BorderRadius.circular(radius),
    );

    final TextStyle errorStyle = Theme.of(context).textTheme.titleSmall!
        .copyWith(color: Theme.of(context).colorScheme.error, height: 1.35);
    final TextStyle style = Theme.of(context).textTheme.titleSmall!.copyWith(
      color:
          isEnabled ?? true
              ? Theme.of(context).textTheme.titleMedium?.color
              : context.appColors.grey,
    );

    final TextStyle hintStyle = Theme.of(
      context,
    ).textTheme.titleSmall!.copyWith(color: context.appColors.grey);

    /// TextField Widget
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          RichText(
            text: TextSpan(
              text: title,
              style:
                  !isEditProfile
                      ? Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(fontSize: 13.sp)
                      : Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(fontSize: 10.sp),
              children:
                  isRequired
                      ? [
                        TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ]
                      : null,
            ),
          ),
          SizedBox(height: 4.h),
        ],

        TextFormField(
          initialValue: initialValue,
          onTap: onTap,
          onChanged: onChanged,
          keyboardType: textInputType,
          controller: controller,
          enabled: isEnabled,
          maxLines: maxLines,
          focusNode: focusNode,
          readOnly: isReadOnly,
          validator: validator,
          maxLength: maxLength,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          autovalidateMode: autoValidateMode ?? AutovalidateMode.disabled,
          obscureText: obscureText ?? false,
          style: style,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            contentPadding:
                contentPadding ??
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
            errorMaxLines: 2,
            errorText: errorText,
            prefixIcon:
                prefixIcon != null
                    ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: prefixIcon,
                    )
                    : null,
            suffixIcon: suffixIcon,
            fillColor: fillColor ?? Theme.of(context).colorScheme.secondary,
            filled: isFilled ?? true,
            hintText: hintText ?? '',
            errorStyle: errorStyle,
            hintStyle: hintStyle,
            labelStyle: Theme.of(context).textTheme.titleMedium,
            disabledBorder: border,
            border: border,
            focusedBorder: activeBorder,
            enabledBorder: border,
            focusedErrorBorder: errorBorder,
            errorBorder: errorBorder,
          ),
        ),
      ],
    );
  }
}
