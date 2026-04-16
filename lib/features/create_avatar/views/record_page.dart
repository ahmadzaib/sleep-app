import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/create_avatar/providers/clone_voice_provider.dart';
import 'package:avatar_flow/widgets/circled_icon_widget.dart';
import 'package:avatar_flow/widgets/custom_button.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class RecordVoicePage extends StatelessWidget {
  const RecordVoicePage();

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Widget _buildRecordingStatus(BuildContext context, bool isRecording) {
    if (!isRecording) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          // width: 28.r,
          // height: 28.r,
          child: SpinKitWave(color: context.appColors.primary, size: 28.r),
        ),
        Spacing.x(2),
        Text(
          "Recording…",
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: context.appColors.primary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: AppConstants.defaultPaddingHorizental.copyWith(
        bottom: 10.h,
        top: 10.h,
      ),
      child: Consumer<CloneVoiceProvider>(
        builder: (context, provider, _) {
          final isRecording = provider.isRecording;
          final hasRecording = provider.audioPath != null;
          final transcript = provider.transcript;
          final voiceDuration = provider.voiceDuration;
          final recordingElapsed = provider.recordingElapsed;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Container(
                width: 1.sw,
                padding: AppConstants.defaultAllPadding,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.largeRadius),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Column(
                  children: [
                    Spacing.y(2),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomSvg(path: AppIconsSvg.wave),
                        CircledIconWidget(
                          color: context.appColors.primary,
                          icon: Icons.graphic_eq,
                        ),
                      ],
                    ),
                    Spacing.y(1.2),
                    _buildRecordingStatus(context, isRecording),
                    Spacing.y(2),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Name of voice",
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Spacing.y(0.8),
                    Divider(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: .3),
                      thickness: 0.5,
                    ),
                    Spacing.y(1.8),
                    Text(
                      hasRecording
                          ? (transcript ?? "Transcript not available")
                          : "Record your voice to generate transcript",
                      textAlign: TextAlign.center,
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface
                            .withValues(alpha: hasRecording ? .9 : .6),
                        height: 1.4,
                      ),
                    ),
                    Spacing.y(2.2),
                    Text(
                      isRecording
                          ? _formatDuration(recordingElapsed)
                          : hasRecording && voiceDuration != null
                          ? _formatDuration(voiceDuration)
                          : "00:00",
                      style: textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: .65),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacing.y(1.6),
                    TextButton(
                      onPressed: hasRecording
                          ? () async => provider.retakeRecording()
                          : null,
                      child: Text(
                        "Retake voice",
                        style: textTheme.bodyMedium?.copyWith(
                          color: hasRecording
                              ? context.appColors.primary
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: .4),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Spacing.y(1),
                    CustomButton(
                      text: isRecording ? 'Stop' : 'Start Recording',
                      // isLoading: isRecording,
                      onPressed: () async {
                        if (isRecording) {
                          await provider.stopRecording();
                        } else {
                          await provider.startRecording();
                        }
                      },
                    ),
                  ],
                ),
              ),
              Spacer(),
              CustomButton(
                text: 'Create Character',
                isDisabled: !hasRecording || isRecording,
                onPressed: !hasRecording || isRecording
                    ? null
                    : () => provider.nextStep(),
              ),
              Spacing.y(1.2),
              TextButton(
                onPressed: isRecording ? null : () => provider.nextStep(),
                child: Text(
                  "Skip and create",
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
