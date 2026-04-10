import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';

class ProfileTile extends StatelessWidget {
  final String title;
  final IconData? leadingIcon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  const ProfileTile({
    super.key,
    required this.title,
    this.leadingIcon,
    this.trailing,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Row(
              children: [
                if (leadingIcon != null) ...[
                  Icon(
                    leadingIcon,
                    size: 20.r,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  16.horizontalSpace,
                ],
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                if (trailing != null)
                  trailing!
                else
                  CustomSvg(
                    path: AppIconsSvg.info,
                    color: context.appColors.grey,
                    height: 20,
                  ),
              ],
            ),
          ),
        ),
        if (showDivider) Divider(),
      ],
    );
  }
}
