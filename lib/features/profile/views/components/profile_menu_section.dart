import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileMenuSection extends StatelessWidget {
  final String title;
  final List<ProfileMenuItemModel> items;

  const ProfileMenuSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
            child: Text(
              title.toUpperCase(),
              style: textTheme.labelMedium?.copyWith(
                color: colors.grey,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                indent: 54.w,
                endIndent: 16.w,
                color: scheme.outlineVariant.withValues(alpha: 0.3),
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return _ProfileMenuItem(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileMenuItemModel {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;
  final Color? color;

  ProfileMenuItemModel({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.color,
  });
}

class _ProfileMenuItem extends StatelessWidget {
  final ProfileMenuItemModel item;

  const _ProfileMenuItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(24.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: (item.color ?? colors.primary).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomSvg(
                path: item.icon,
                size: 18.sp,
                color: item.color ?? colors.iconColor,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                item.label,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: item.color,
                ),
              ),
            ),
            item.trailing ??
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: colors.grey.withValues(alpha: 0.5),
                ),
          ],
        ),
      ),
    );
  }
}
