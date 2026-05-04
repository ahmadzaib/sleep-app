import 'package:avatar_flow/core/theme/app_colors.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/avatar/providers/avatar_share_provider.dart';
import 'package:avatar_flow/features/avatar/views/components/share_avatar_bottom_sheet.dart';
import 'package:avatar_flow/features/avatar/views/components/user_tile.dart';
import 'package:avatar_flow/widgets/circled_icon_widget.dart';
import 'package:avatar_flow/widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SharedWithUsersSection extends StatefulWidget {
  final int avatarId;
  const SharedWithUsersSection({super.key, required this.avatarId});

  @override
  State<SharedWithUsersSection> createState() => _SharedWithUsersSectionState();
}

class _SharedWithUsersSectionState extends State<SharedWithUsersSection> {
  int _visibleCount = 4;

  @override
  void initState() {
    super.initState();
    // Fetch recipients on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AvatarShareProvider>().fetchRecipients(widget.avatarId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Consumer<AvatarShareProvider>(
      builder: (context, provider, child) {
        final users = provider.recipients;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Shared with', style: textTheme.bodyMedium),
                const Spacer(),
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () =>
                      ShareAvatarBottomSheet.show(context, widget.avatarId),
                  child: Text(
                    'Add',
                    style: textTheme.bodyMedium!.copyWith(
                      color: context.appColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (users.isNotEmpty) ...[
                  SizedBox(width: 12.w),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => ConfirmationDialog.show(
                      content: CircledIconWidget(
                        color: context.appColors.error,
                        icon: Icons.warning,
                      ),
                      context: context,
                      title: "Remove All Users",
                      subtitle: "Are you sure you want to remove all users?",
                      confirmText: "Remove All",
                      onConfirm: () => provider.revokeAll(widget.avatarId),
                      cancelText: "Cancel",
                    ),
                    child: Text(
                      'Remove all',
                      style: textTheme.bodyMedium!.copyWith(
                        color: context.appColors.error,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            Spacing.y(1),
            if (provider.isLoading)
              _buildShimmer()
            else if (users.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Text(
                  'No users shared yet',
                  style: textTheme.bodySmall?.copyWith(
                    color: context.appColors.grey.withValues(alpha: 0.6),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount:
                    users.length > _visibleCount ? _visibleCount : users.length,
                separatorBuilder: (context, index) => Divider(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: .05),
                  height: 1.h,
                  thickness: 1.4,
                ),
                itemBuilder: (context, index) {
                  final user = users[index];
                  return UserTile(
                    name: user.name ?? user.email,
                    email: user.email,
                    avatarUrl: user.avatarUrl,
                    onRemoveTap: () => ConfirmationDialog.show(
                      content: CircledIconWidget(
                        color: context.appColors.error,
                        icon: Icons.warning,
                      ),
                      context: context,
                      title: "Remove User",
                      subtitle: "Are you sure you want to remove this user?",
                      confirmText: "Remove",
                      onConfirm: () =>
                          provider.revokeShare(widget.avatarId, user.id),
                      cancelText: "Cancel",
                    ),
                  );
                },
              ),
            if (!provider.isLoading && _visibleCount < users.length)
              Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: TextButton(
                  onPressed: () => setState(() => _visibleCount = users.length),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
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
      },
    );
  }

  Widget _buildShimmer() {
    return Column(
      children: List.generate(3, (index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Shimmer.fromColors(
            baseColor: context.appColors.lightGrey,
            highlightColor: context.appColors.bubbleGray,
            child: Row(
              children: [
                Container(
                  width: 30.r,
                  height: 30.r,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100.w,
                        height: 14.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      Spacing.y(.6),
                      Container(
                        width: 150.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
