import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String title;
  final String hint;
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemLabel;
  final bool isOptional;

  const CustomDropdown({
    super.key,
    required this.title,
    required this.hint,
    required this.items,
    required this.onChanged,
    required this.itemLabel,
    this.value,
    this.isOptional = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isExpanded: true,
        hint: Text(
          hint,
          style: textTheme.bodyMedium?.copyWith(color: context.appColors.grey),
        ),
        value: value,
        items:
            items
                .map(
                  (item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      itemLabel(item),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                )
                .toList(),
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(AppConstants.largeRadius),
          ),
        ),
        iconStyleData: IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20.r,
            color: colorScheme.onSurface,
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 220.h,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppConstants.largeRadius),
          ),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: WidgetStateProperty.all(6),
            thumbVisibility: WidgetStateProperty.all(true),
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 44.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
        selectedItemBuilder:
            (context) =>
                items
                    .map(
                      (item) => Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          itemLabel(item),
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    )
                    .toList(),
      ),
    );
  }
}
