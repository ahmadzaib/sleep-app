import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final bool isSelected;
  final String price;
  final String period;
  final String rightLabel;
  final String rightSub;
  final VoidCallback onTap;
  final Widget? badge;

  const SubscriptionPlanCard({
    super.key,
    required this.isSelected,
    required this.price,
    required this.period,
    required this.rightLabel,
    required this.rightSub,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppConstants.mediumRadius),
                bottom: badge == null
                    ? Radius.circular(AppConstants.mediumRadius)
                    : Radius.zero,
              ),
              border: Border.all(
                color: isSelected ? scheme.primary : colors.lightGrey,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Radio
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? scheme.primary : colors.lightGrey,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 10.w,
                            height: 10.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: scheme.primary,
                            ),
                          ),
                        )
                      : null,
                ),
                SizedBox(width: 12.w),
                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      price,
                      style: textTheme.headlineSmall?.copyWith(
                        color: colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      period,
                      style: textTheme.bodySmall?.copyWith(color: colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                // Right label
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      rightLabel,
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacing.y(.5),
                    Text(
                      rightSub,
                      style: textTheme.bodySmall?.copyWith(color: colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (badge != null) badge!,
        ],
      ),
    );
  }
}

class BestValueBadge extends StatelessWidget {
  const BestValueBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C4DFF), Color(0xFF9C6FFF)],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppConstants.mediumRadius),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Best Value ',
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('⭐', style: TextStyle(fontSize: 12)),
            ],
          ),
          Text(
            'Save 48% with the annual plan!',
            style: textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
