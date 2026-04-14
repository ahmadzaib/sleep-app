// reusable_popup_menu.dart

import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuItemConfig {
  final String value;
  final String iconPath;
  final String label;

  const MenuItemConfig({
    required this.value,
    required this.iconPath,
    required this.label,
  });
}

class ReusablePopupMenu extends StatelessWidget {
  final List<MenuItemConfig> items;
  final void Function(String value) onSelected;
  final String iconPath;
  final double iconSize;
  final EdgeInsets? itemPadding;

  const ReusablePopupMenu({
    super.key,
    required this.items,
    required this.onSelected,
    required this.iconPath,
    this.iconSize = 18,
    this.itemPadding,
  });

  PopupMenuItem<String> _buildItem(
    BuildContext context,
    MenuItemConfig config,
  ) {
    final iconColor = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: .6);
    final textStyle = Theme.of(context).textTheme.bodyMedium;

    return PopupMenuItem<String>(
      value: config.value,
      padding: itemPadding ?? EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          CustomSvg(path: config.iconPath, size: iconSize, color: iconColor),
          Spacing.x(2),
          Text(config.label, style: textStyle),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      elevation: 0,
      position: PopupMenuPosition.under,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
      ),
      icon: CustomSvg(path: iconPath),
      onSelected: onSelected,
      itemBuilder: (context) =>
          items.map((item) => _buildItem(context, item)).toList(),
    );
  }
}
