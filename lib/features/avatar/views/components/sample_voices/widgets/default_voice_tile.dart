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

/// Default Voice Tile - first item in the list
class DefaultVoiceTile extends StatelessWidget {
  const DefaultVoiceTile({super.key});

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
            VoiceSelectionIndicator(isSelected: isSelected),
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
