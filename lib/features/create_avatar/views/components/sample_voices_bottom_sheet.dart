import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/create_avatar/providers/create_avatar_provider.dart';
import 'package:avatar_flow/features/create_avatar/providers/clone_voice_provider.dart';
import 'package:avatar_flow/widgets/custom_button.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SampleVoicesBottomSheet extends StatefulWidget {
  const SampleVoicesBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.extraLargeRadius),
        ),
      ),
      builder: (_) => const SampleVoicesBottomSheet(),
    );
  }

  @override
  State<SampleVoicesBottomSheet> createState() =>
      _SampleVoicesBottomSheetState();
}

class _SampleVoicesBottomSheetState extends State<SampleVoicesBottomSheet> {
  static const List<String> categoryLabels = [
    'All',
    'Man',
    'Woman',
    'Excited',
    'Calm',
    'Serious',
    'Deep',
    'Random',
  ];

  final List<Map<String, dynamic>> voices = const [
    {
      'name': 'Voice 1',
      'tags': ['Man', 'Serious', 'Deep'],
    },
    {
      'name': 'Voice 2',
      'tags': ['Woman', 'Calm', 'Random'],
    },
    {
      'name': 'Voice 3',
      'tags': ['Excited', 'Random'],
    },
  ];

  String _activeCategory = categoryLabels.first;

  List<Map<String, dynamic>> get _filteredVoices {
    if (_activeCategory == 'All') return voices;
    return voices
        .where((v) => (v['tags'] as List<String>).contains(_activeCategory))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final createProvider = context.watch<CreateAvatarProvider>();

    return Padding(
      padding: EdgeInsets.only(
        left: AppConstants.paddingOnly,
        right: AppConstants.paddingOnly,
        top: AppConstants.paddingOnly.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      child: SizedBox(
        height: 0.78.sh,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: context.appColors.lightGrey,
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
            ),
            Spacing.y(1.6),
            Center(
              child: Text(
                "Choose Your Hero's Voice!",
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                ),
              ),
            ),
            Spacing.y(2),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: categoryLabels.map((label) {
                final isActive = label == _activeCategory;
                return InkWell(
                  borderRadius: BorderRadius.circular(999.r),
                  onTap: () {
                    setState(() {
                      _activeCategory = label;
                    });

                    final createProvider = context.read<CreateAvatarProvider>();
                    final selected = createProvider.selectedVoice;
                    final filtered = _filteredVoices;

                    if (filtered.isEmpty) return;

                    final idx = filtered.indexWhere(
                      (v) => v['name'] as String == selected,
                    );
                    if (idx < 0) {
                      final firstVoice = filtered.first['name'] as String;
                      createProvider.updateVoice(firstVoice);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999.r),
                      border: !isActive
                          ? Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: .3),
                            )
                          : null,
                      color: isActive
                          ? context.appColors.secondary
                          : Colors.transparent,
                    ),
                    child: Text(
                      label,
                      style: textTheme.bodySmall?.copyWith(
                        color: isActive
                            ? Theme.of(context).colorScheme.onPrimary
                            : label == "Random"
                            ? context.appColors.primary
                            : context.appColors.grey,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            Spacing.y(2),
            Expanded(
              child: ListView.separated(
                itemCount: _filteredVoices.length,
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final voice = _filteredVoices[index];
                  final name = voice['name'] as String;

                  return InkWell(
                    borderRadius: BorderRadius.circular(16.r),
                    onTap: () {
                      createProvider.updateVoice(name);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: name,

                            groupValue: createProvider.selectedVoice,
                            onChanged: (_) {
                              createProvider.updateVoice(name);
                            },
                          ),
                          Expanded(
                            child: Text(
                              name,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          IconButton(
                            onPressed: () {},
                            icon: CustomSvg(path: AppIconsSvg.heart),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: CustomSvg(path: AppIconsSvg.play),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Spacing.y(1.2),
            CustomButton(
              buttonColor: context.appColors.primary.withValues(alpha: .2),

              textColor: context.appColors.primary,
              text: "Clone your voice",
              onPressed: () {
                Navigator.of(context).pop();
                context.read<CloneVoiceProvider>().nextStep();
              },
            ),

            Spacing.y(1),
            CustomButton(
              text: "Save",
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
