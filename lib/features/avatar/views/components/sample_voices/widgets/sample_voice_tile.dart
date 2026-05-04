import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/features/avatar/providers/create_avatar_provider.dart';
import 'package:avatar_flow/features/avatar/providers/sample_voices_provider.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'voice_selection_indicator.dart';
import 'waveform_widget.dart';

class SampleVoiceTile extends StatelessWidget {
  const SampleVoiceTile({super.key, required this.voice});

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
            VoiceSelectionIndicator(isSelected: isSelected),
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
                  WaveformWidget(isActive: isPlaying),
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
