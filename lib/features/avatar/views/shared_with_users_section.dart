import 'package:avatar_flow/core/theme/app_colors.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/avatar/views/components/user_tile.dart';
import 'package:avatar_flow/widgets/circled_icon_widget.dart';
import 'package:avatar_flow/widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SharedWithUsersSection extends StatefulWidget {
  const SharedWithUsersSection({super.key});

  @override
  State<SharedWithUsersSection> createState() => _SharedWithUsersSectionState();
}

class _SharedWithUsersSectionState extends State<SharedWithUsersSection> {
  final int _totalUsers = 10;
  int _visibleCount = 4;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Shared with', style: textTheme.bodyMedium),
            TextButton(
              style: TextButton.styleFrom(
                // padding: EdgeInsets.symmetric(horizontal: 16.w),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {
                ConfirmationDialog.show(
                  content: CircledIconWidget(
                    color: context.appColors.error,
                    icon: Icons.warning,
                  ),
                  context: context,
                  title: "Remove All Users",
                  subtitle: "Are you sure, You want to remove all users?",
                  confirmText: "Remove All",
                  cancelText: "Cancel",
                );
              },
              child: Text(
                'Remove all',
                style: textTheme.bodyMedium!.copyWith(
                  color: context.appColors.error,
                ),
              ),
            ),
          ],
        ),
        Spacing.y(1),
        ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _visibleCount,
          separatorBuilder: (context, index) => Divider(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: .05),
            height: 1.h,
            thickness: 1.4,
          ),
          itemBuilder: (context, index) {
            return UserTile(
              onRemoveTap: () {
                ConfirmationDialog.show(
                  content: CircledIconWidget(
                    color: context.appColors.error,
                    icon: Icons.warning,
                  ),
                  context: context,
                  title: "Remove User",
                  subtitle: "Are you sure, You want to remove this user?",
                  confirmText: "Remove",
                  cancelText: "Cancel",
                );
              },
            );
          },
        ),
        if (_visibleCount < _totalUsers)
          Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: TextButton(
              onPressed: () {
                setState(() {
                  _visibleCount = _totalUsers;
                });
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                  side: BorderSide(color: AppColors.primary100),
                ),
              ),
              child: Text(
                'View more',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary100,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
