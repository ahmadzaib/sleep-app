import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/subscription/providers/subscription_provider.dart';
import 'package:avatar_flow/features/subscription/views/components/free_plan_button.dart';
import 'package:avatar_flow/features/subscription/views/components/plan_card.dart';
import 'package:avatar_flow/features/subscription/views/components/subscription_hero.dart';
import 'package:avatar_flow/features/subscription/views/components/trust_row.dart';
import 'package:avatar_flow/widgets/bg_widget.dart';
import 'package:avatar_flow/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;
    final subscriptionProvider = context.watch<SubscriptionProvider>();

    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: AppConstants.defaultPaddingHorizental,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // ── Hero image ─────────────────────────────────────────
              const SubscriptionHero(),
              Spacing.y(1),

              // ── Title ──────────────────────────────────────────────
              Text(
                'Unlock Unlimited Stories &\nCharacters!',
                textAlign: TextAlign.center,
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                  fontSize: 25.sp,
                ),
              ),
              Text(
                'One simple plan for full access to all stories,\ncharacters, and creative tools.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(color: colors.grey),
              ),
              Spacing.y(1),

              // ── Annual plan card ───────────────────────────────────
              SubscriptionPlanCard(
                isSelected: subscriptionProvider.isAnnual,
                price: '\$124.99',
                period: 'per year',
                rightLabel: 'Full access by',
                rightSub: "That's \$10.42/mo",
                onTap: () => subscriptionProvider.setIsAnnual(true),
                badge: const BestValueBadge(),
              ),

              // ── Monthly plan card ──────────────────────────────────
              SubscriptionPlanCard(
                isSelected: !subscriptionProvider.isAnnual,
                price: '\$19.99',
                period: 'per month',
                rightLabel: 'Full access by',
                rightSub: "That's \$19.99/mo",
                onTap: () => subscriptionProvider.setIsAnnual(false),
              ),
              Spacing.y(1),

              // ── Trust badges ───────────────────────────────────────
              SubscriptionTrustRow(
                svgPath: AppIconsSvg.lock,
                text: 'Secure payment processing',
              ),
              SubscriptionTrustRow(
                svgPath: AppIconsSvg.dollar,
                text: '30-day money-back guarantee—no questions asked',
              ),

              Spacing.y(1),

              // ── Free trial CTA ─────────────────────────────────────
              Text(
                'Try full access free for 7 days—cancel anytime!',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacing.y(1),

              // ── Get full access button ─────────────────────────────
              CustomButton(text: "Get Full Access Now", onPressed: () {}),
              Spacing.y(1),

              // ── Free plan ─────────────────────────────────────────
              const ContinueFreePlanButton(),
            ],
          ),
        ),
      ),
    );
  }
}
