import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _isAnnual = true;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 16.h),

              // ── Hero image ─────────────────────────────────────────
              SizedBox(
                height: 200.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Triangle beam
                    Positioned(
                      top: 0,
                      child: Image.asset(
                        AppImagesPng.triangle,
                        height: 180.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                    // Stars scattered
                    Positioned(
                      bottom: 20.h,
                      child: Image.asset(
                        AppImagesPng.stars,
                        height: 160.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                    // Badge center
                    Positioned(
                      bottom: 0,
                      child: Image.asset(
                        AppImagesPng.badge,
                        height: 100.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // ── Title ──────────────────────────────────────────────
              Text(
                'Unlock Unlimited Stories &\nCharacters!',
                textAlign: TextAlign.center,
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'One simple plan for full access to all stories,\ncharacters, and creative tools.',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(color: colors.grey),
              ),
              SizedBox(height: 24.h),

              // ── Annual plan card ───────────────────────────────────
              _PlanCard(
                isSelected: _isAnnual,
                price: '\$124.99',
                period: 'per year',
                rightLabel: 'Full access by',
                rightSub: "That's \$10.42/mo",
                onTap: () => setState(() => _isAnnual = true),
                badge: _BestValueBadge(),
              ),
              SizedBox(height: 12.h),

              // ── Monthly plan card ──────────────────────────────────
              _PlanCard(
                isSelected: !_isAnnual,
                price: '\$19.99',
                period: 'per month',
                rightLabel: 'Full access by',
                rightSub: "That's \$19.99/mo",
                onTap: () => setState(() => _isAnnual = false),
              ),
              SizedBox(height: 24.h),

              // ── Trust badges ───────────────────────────────────────
              _TrustRow(
                icon: Icons.lock_outline_rounded,
                text: 'Secure payment processing',
                colors: colors,
                textTheme: textTheme,
              ),
              SizedBox(height: 10.h),
              _TrustRow(
                icon: Icons.replay_rounded,
                text: '30-day money-back guarantee—no questions asked',
                colors: colors,
                textTheme: textTheme,
              ),
              SizedBox(height: 10.h),
              _TrustRow(
                icon: Icons.star_rounded,
                text:
                    '"Perfect for creating bedtime stories my kids love!" – Sarah',
                colors: colors,
                textTheme: textTheme,
                iconColor: Colors.amber,
                trailing: Text(
                  '4.5',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // ── Free trial CTA ─────────────────────────────────────
              Text(
                'Try full access free for 7 days—cancel anytime!',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 14.h),

              // ── Get full access button ─────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.secondary,
                    foregroundColor: scheme.onPrimary,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.extraLargeRadius,
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Get Full Access Now',
                    style: textTheme.headlineSmall?.copyWith(
                      color: scheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // ── Free plan ─────────────────────────────────────────
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Column(
                  children: [
                    Text(
                      'Continue with the free plan',
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Limited access to basic stories and tools.',
                      style: textTheme.bodySmall?.copyWith(color: colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Plan selection card ───────────────────────────────────────────────────────
class _PlanCard extends StatelessWidget {
  final bool isSelected;
  final String price;
  final String period;
  final String rightLabel;
  final String rightSub;
  final VoidCallback onTap;
  final Widget? badge;

  const _PlanCard({
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
                width: isSelected ? 2 : 1,
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
                        color: scheme.primary,
                        fontWeight: FontWeight.bold,
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

// ── Best value badge ──────────────────────────────────────────────────────────
class _BestValueBadge extends StatelessWidget {
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

// ── Trust row ─────────────────────────────────────────────────────────────────
class _TrustRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final AppColorsExtension colors;
  final TextTheme textTheme;
  final Color? iconColor;
  final Widget? trailing;

  const _TrustRow({
    required this.icon,
    required this.text,
    required this.colors,
    required this.textTheme,
    this.iconColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18.sp, color: iconColor ?? colors.primary),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            text,
            style: textTheme.bodySmall?.copyWith(color: colors.grey),
          ),
        ),
        if (trailing != null) ...[SizedBox(width: 6.w), trailing!],
      ],
    );
  }
}
