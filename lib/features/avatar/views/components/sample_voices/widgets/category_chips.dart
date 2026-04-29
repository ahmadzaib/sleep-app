import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/features/avatar/providers/create_avatar_provider.dart';
import 'package:avatar_flow/features/avatar/providers/sample_voices_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final categoryLabels = context.select<SampleVoicesProvider, List<String>>(
      (provider) => provider.categoryLabels,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 8.w,
        children: categoryLabels.map((label) {
          return Selector<SampleVoicesProvider, bool>(
            selector: (_, provider) => provider.selectedCategory == label,
            builder: (context, isActive, _) {
              return InkWell(
                borderRadius: BorderRadius.circular(999.r),
                onTap: () {
                  final sampleProvider = context.read<SampleVoicesProvider>();
                  final createProvider = context.read<CreateAvatarProvider>();

                  sampleProvider.selectCategory(label);

                  // Check if current sample voice is in this category
                  if (createProvider.selectedSampleVoiceId != null &&
                      sampleProvider.containsVoice(
                        createProvider.selectedSampleVoiceId!,
                      )) {
                    return;
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999.r),
                    border: isActive
                        ? null
                        : Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: .3),
                          ),
                    color: isActive
                        ? context.appColors.secondary
                        : Colors.transparent,
                  ),
                  child: Text(
                    label,
                    style: textTheme.bodySmall?.copyWith(
                      color: isActive
                          ? Theme.of(context).colorScheme.onPrimary
                          : label == 'Random'
                          ? context.appColors.primary
                          : context.appColors.grey,
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
