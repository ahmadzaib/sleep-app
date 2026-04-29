import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/avatar/providers/create_avatar_provider.dart';
import 'package:avatar_flow/features/avatar/providers/sample_voices_provider.dart';
import 'package:avatar_flow/widgets/app_loading.dart';
import 'package:avatar_flow/widgets/custom_button.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SampleVoicesBottomSheet extends StatelessWidget {
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
      builder: (_) => ChangeNotifierProvider(
        create: (_) => SampleVoicesProvider(),
        child: const SampleVoicesBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            const _BottomSheetHandle(),
            Spacing.y(1.6),
            const _Title(),
            Spacing.y(2),
            const _CategoryChips(),
            Spacing.y(2),
            const Expanded(child: _VoicesList()),
            Spacing.y(1),
            CustomButton(
              buttonColor: context.appColors.primary.withValues(alpha: .2),
              textColor: context.appColors.primary,
              text: "Clone your voice instead",
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to voice clone/record screen
                context.read<CreateAvatarProvider>().useDefaultVoice();
                ();
              },
            ),
            Spacing.y(1),
            CustomButton(
              text: "Save Selection",
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

class _BottomSheetHandle extends StatelessWidget {
  const _BottomSheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 42.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: context.appColors.lightGrey,
          borderRadius: BorderRadius.circular(999.r),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Text(
        "Choose Your Hero's Voice!",
        style: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 18.sp,
        ),
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips();

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

                  // Auto-select first voice in category
                  final fallbackVoiceId = sampleProvider.firstFilteredVoiceId;
                  final fallbackVoiceName =
                      sampleProvider.firstFilteredVoiceName;
                  final fallbackVoiceUrl = sampleProvider.filteredVoices.isEmpty
                      ? null
                      : sampleProvider.filteredVoices.first.audioPath;
                  if (fallbackVoiceId != null) {
                    createProvider.selectSampleVoice(
                      fallbackVoiceId,
                      name: fallbackVoiceName,
                      url: fallbackVoiceUrl,
                    );
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

class _VoicesList extends StatelessWidget {
  const _VoicesList();

  @override
  Widget build(BuildContext context) {
    return Consumer<SampleVoicesProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: AppLoading());
        }

        final voices = provider.filteredVoices;

        // Build list with default voice as first item
        final itemCount = voices.isEmpty ? 1 : voices.length + 1;

        return ListView.separated(
          itemCount: itemCount,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            // First item is always the Default voice
            if (index == 0) {
              return const _DefaultVoiceTile();
            }
            // Rest are sample voices
            return _SampleVoiceTile(voice: voices[index - 1]);
          },
        );
      },
    );
  }
}

class _SampleVoiceTile extends StatelessWidget {
  const _SampleVoiceTile({required this.voice});

  final SampleVoice voice;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isSelected = context.select<CreateAvatarProvider, bool>(
      (provider) => provider.selectedSampleVoiceId == voice.id,
    );
    final isFavorite = context.select<SampleVoicesProvider, bool>(
      (provider) => provider.isFavorite(voice.id),
    );
    final isPlaying = context.select<SampleVoicesProvider, bool>(
      (provider) => provider.isPlaying(voice.id),
    );

    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: () {
        // Select this sample voice - this also clears any recorded voice
        context.read<CreateAvatarProvider>().selectSampleVoice(
          voice.id,
          name: voice.name,
          url: voice.audioPath,
        );
      },
      child: AnimatedContainer(
        duration: AppConstants.defaultDuration,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? context.appColors.primary.withValues(alpha: 0.08)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? context.appColors.primary.withValues(alpha: 0.4)
                : Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          children: [
            _VoiceSelectionIndicator(isSelected: isSelected),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    voice.name,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    voice.tags.join(' • '),
                    style: textTheme.bodySmall?.copyWith(
                      color: context.appColors.grey,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _Waveform(isActive: isPlaying),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            IconButton(
              onPressed: () {
                context.read<SampleVoicesProvider>().toggleFavorite(voice.id);
              },
              icon: CustomSvg(
                path: AppIconsSvg.heart,
                color: isFavorite
                    ? context.appColors.error
                    : context.appColors.grey,
              ),
            ),
            IconButton(
              onPressed: () {
                context.read<SampleVoicesProvider>().togglePlayback(voice);
              },
              icon: CustomSvg(
                path: isPlaying ? AppIconsSvg.pause : AppIconsSvg.play,
                color: context.appColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VoiceSelectionIndicator extends StatelessWidget {
  const _VoiceSelectionIndicator({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppConstants.defaultDuration,
      width: 22.w,
      height: 22.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? context.appColors.primary
              : context.appColors.grey.withValues(alpha: 0.5),
          width: 1.6,
        ),
      ),
      child: Center(
        child: AnimatedContainer(
          duration: AppConstants.defaultDuration,
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? context.appColors.primary : Colors.transparent,
          ),
        ),
      ),
    );
  }
}

class _Waveform extends StatelessWidget {
  const _Waveform({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final baseColor = isActive
        ? context.appColors.primary
        : context.appColors.grey.withValues(alpha: 0.45);

    return Row(
      children: List.generate(
        14,
        (index) => Container(
          margin: EdgeInsets.only(right: 3.w),
          width: 3.w,
          height: ((index % 4) + 2) * 4.h,
          decoration: BoxDecoration(
            color: baseColor.withValues(
              alpha: isActive ? (0.45 + (index % 4) * 0.12) : 1,
            ),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ),
    );
  }
}

/// Default Voice Tile - first item in the list
class _DefaultVoiceTile extends StatelessWidget {
  const _DefaultVoiceTile();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isSelected = context.select<CreateAvatarProvider, bool>(
      (provider) => provider.isUsingDefaultVoice,
    );
    final isPlaying = context.select<SampleVoicesProvider, bool>(
      (provider) => provider.isPlaying('default_voice'),
    );
    final createProvider = context.read<CreateAvatarProvider>();
    final gender = createProvider.selectedGender;
    final defaultVoiceId = gender.toLowerCase() == 'male'
        ? CreateAvatarProvider.defaultMaleVoiceId
        : CreateAvatarProvider.defaultFemaleVoiceId;

    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: () => context.read<CreateAvatarProvider>().useDefaultVoice(),
      child: AnimatedContainer(
        duration: AppConstants.defaultDuration,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? context.appColors.primary.withValues(alpha: 0.08)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? context.appColors.primary.withValues(alpha: 0.4)
                : Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          children: [
            _VoiceSelectionIndicator(isSelected: isSelected),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Default Voice',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Standard AI voice',
                    style: textTheme.bodySmall?.copyWith(
                      color: context.appColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                final sampleProvider = context.read<SampleVoicesProvider>();
                // Play TTS with default voice using text-to-speech
                await sampleProvider.playDefaultVoice(defaultVoiceId);
              },
              icon: CustomSvg(
                path: isPlaying ? AppIconsSvg.pause : AppIconsSvg.play,
                color: context.appColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
