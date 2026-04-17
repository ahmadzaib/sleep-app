import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileStats extends StatelessWidget {
  final int avatarsCount;
  final int storiesCount;
  final double rating;

  const ProfileStats({
    super.key,
    required this.avatarsCount,
    required this.storiesCount,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(
            value: avatarsCount.toString(),
            label: 'Avatars',
            textTheme: textTheme,
            colors: colors,
          ),
          _VerticalDivider(),
          _StatItem(
            value: storiesCount.toString(),
            label: 'Stories',
            textTheme: textTheme,
            colors: colors,
          ),
          _VerticalDivider(),
          _StatItem(
            value: rating.toString(),
            label: 'Rating',
            textTheme: textTheme,
            colors: colors,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final TextTheme textTheme;
  final AppColorsExtension colors;

  const _StatItem({
    required this.value,
    required this.label,
    required this.textTheme,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 20.sp,
          ),
        ),
        Spacing.y(0.4),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      width: 1,
      color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
    );
  }
}
