import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/widgets/custom_cache_netword_imge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserTile extends StatelessWidget {
  final String? name;
  final String? email;
  final String? avatarUrl;
  final VoidCallback onRemoveTap;

  const UserTile({
    super.key,
    this.name,
    this.email,
    this.avatarUrl,
    required this.onRemoveTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          CustomCachedNetworkImage(
            imageUrl: avatarUrl,
            height: 30.r,
            width: 30.r,
            borderRadius: 30.r,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (name != null)
                  Text(
                    name!,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                if (email != null) ...[
                  Spacing.y(.4),
                  Text(
                    email!,
                    style: textTheme.bodySmall?.copyWith(
                      letterSpacing: 0,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: .5),
                    ),
                  ),
                ],
              ],
            ),
          ),
          TextButton(
            onPressed: onRemoveTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Remove',
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
                color: context.appColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
