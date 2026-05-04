import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/milestones/models/milestone_with_task.dart';
import 'package:avatar_flow/features/milestones/providers/milestones_provider.dart';
import 'package:avatar_flow/widgets/app_loading.dart';
import 'package:avatar_flow/widgets/bg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MilestonesScreen extends StatefulWidget {
  const MilestonesScreen({super.key});

  @override
  State<MilestonesScreen> createState() => _MilestonesScreenState();
}

class _MilestonesScreenState extends State<MilestonesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MilestonesProvider>().fetchMilestones();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;

    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Milestones',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<MilestonesProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: AppLoading());
            }

            if (provider.error != null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48.sp, color: colors.error),
                    Spacing.y(1.5),
                    Text(
                      'Failed to load milestones',
                      style: textTheme.bodyMedium?.copyWith(color: colors.grey),
                    ),
                    Spacing.y(2),
                    TextButton(
                      onPressed: provider.fetchMilestones,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (provider.milestones.isEmpty) {
              return Center(
                child: Text(
                  'No milestones yet.',
                  style: textTheme.bodyMedium?.copyWith(color: colors.grey),
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              itemCount: provider.milestones.length,
              separatorBuilder: (_, __) => Spacing.y(1.5),
              itemBuilder: (context, index) {
                return _MilestoneTile(item: provider.milestones[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

// ── Single milestone tile ─────────────────────────────────────────────────────
class _MilestoneTile extends StatelessWidget {
  final MilestoneWithTask item;

  const _MilestoneTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final textTheme = theme.textTheme;
    final scheme = theme.colorScheme;

    // State-based styling
    final Color accentColor = item.isCompleted
        ? colors.success
        : item.isUnlocked
        ? scheme.primary
        : colors.grey;

    final Color bgColor = item.isCompleted
        ? colors.success.withValues(alpha: 0.06)
        : item.isUnlocked
        ? scheme.surface
        : scheme.surface.withValues(alpha: 0.5);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        border: Border.all(
          color: item.isUnlocked && !item.isCompleted
              ? scheme.primary.withValues(alpha: 0.25)
              : Colors.transparent,
        ),
        boxShadow: item.isLocked ? [] : [AppConstants.defaultShadow],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Badge / icon ───────────────────────────────────────────
          _MilestoneBadge(item: item, accentColor: accentColor),
          SizedBox(width: 14.w),

          // ── Content ────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order + title row
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'Stage ${item.milestone.orderIndex}',
                        style: textTheme.bodySmall?.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                    if (item.isCompleted) ...[
                      SizedBox(width: 6.w),
                      Icon(
                        Icons.check_circle_rounded,
                        size: 14.sp,
                        color: colors.success,
                      ),
                    ],
                  ],
                ),
                Spacing.y(0.6),
                Text(
                  item.milestone.title,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: item.isLocked
                        ? scheme.onSurface.withValues(alpha: 0.4)
                        : null,
                  ),
                ),
                Spacing.y(0.8),

                // ── Task info ────────────────────────────────────────
                if (item.task != null) ...[
                  _TaskRow(item: item, accentColor: accentColor),
                  Spacing.y(1),
                  _ProgressBar(item: item, accentColor: accentColor),
                ] else
                  Text(
                    'No task assigned',
                    style: textTheme.bodySmall?.copyWith(color: colors.grey),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Badge ─────────────────────────────────────────────────────────────────────
class _MilestoneBadge extends StatelessWidget {
  final MilestoneWithTask item;
  final Color accentColor;

  const _MilestoneBadge({required this.item, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    if (item.isCompleted) {
      return Image.asset(AppImagesPng.milestoneCheck2, height: 48.h);
    }
    if (item.isLocked) {
      return Container(
        width: 48.w,
        height: 48.h,
        decoration: BoxDecoration(
          color: context.appColors.lightGrey,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.lock_outline_rounded,
          size: 22.sp,
          color: context.appColors.grey,
        ),
      );
    }
    // Active / unlocked
    return Image.asset(AppImagesPng.milestoneCheck, height: 48.h);
  }
}

// ── Task row ──────────────────────────────────────────────────────────────────
class _TaskRow extends StatelessWidget {
  final MilestoneWithTask item;
  final Color accentColor;

  const _TaskRow({required this.item, required this.accentColor});

  String _formatTaskType(String type) {
    return type
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;

    return Row(
      children: [
        Icon(Icons.flag_outlined, size: 13.sp, color: accentColor),
        SizedBox(width: 5.w),
        Expanded(
          child: Text(
            _formatTaskType(item.task!.taskType),
            style: textTheme.bodySmall?.copyWith(
              color: item.isLocked
                  ? colors.grey.withValues(alpha: 0.5)
                  : colors.grey,
            ),
          ),
        ),
        Text(
          '${item.currentCount} / ${item.targetCount}',
          style: textTheme.bodySmall?.copyWith(
            color: accentColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ── Progress bar ──────────────────────────────────────────────────────────────
class _ProgressBar extends StatelessWidget {
  final MilestoneWithTask item;
  final Color accentColor;

  const _ProgressBar({required this.item, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(99.r),
      child: LinearProgressIndicator(
        value: item.progress,
        minHeight: 6.h,
        backgroundColor: scheme.onSurface.withValues(alpha: 0.08),
        valueColor: AlwaysStoppedAnimation<Color>(accentColor),
      ),
    );
  }
}
