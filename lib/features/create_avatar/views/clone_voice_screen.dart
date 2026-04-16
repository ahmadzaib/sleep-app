import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/create_avatar/providers/clone_voice_provider.dart';
import 'package:avatar_flow/widgets/bg_widget.dart';
import 'package:avatar_flow/widgets/circled_icon_widget.dart';
import 'package:avatar_flow/widgets/custom_app_bar.dart';
import 'package:avatar_flow/widgets/custom_button.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CloneVoiceScreen extends StatelessWidget {
  const CloneVoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CloneVoiceView();
  }
}

class _CloneVoiceView extends StatelessWidget {
  const _CloneVoiceView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CloneVoiceProvider>();

    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(title: "Clone Voice"),
        body: SafeArea(
          child: Column(
            children: [
              _StepIndicator(currentStep: provider.currentStep),
              Spacing.y(1.5),
              Expanded(
                child: PageView(
                  controller: provider.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    _AgreementPage(),
                    _RecordVoicePage(),
                    _VoiceCharacteristicsPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    const labels = ['Agreement', 'Record', 'Characteristics'];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: List.generate(labels.length, (index) {
          final isActive = index == currentStep;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: AppConstants.defaultDuration,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: isActive
                          ? context.appColors.secondary
                          : context.appColors.lightGrey,
                      borderRadius: BorderRadius.circular(
                        AppConstants.extraLargeRadius,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _AgreementPage extends StatelessWidget {
  const _AgreementPage();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: AppConstants.defaultPaddingHorizental.copyWith(
        bottom: 10.h,
        top: 10.h,
      ),
      child: Column(
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
                      icon: Icons.mic,
                    ),
                  ],
                ),
                Spacing.y(2),

                Text(
                  "Clone your voice",
                  style: textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacing.y(2),
                Text(
                  "Add personalized voices to your characters by cloning your voice",
                  style: textTheme.bodyMedium!.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: .6),
                  ),
                  textAlign: TextAlign.center,
                ),
                Spacing.y(2),
                Divider(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: .3),
                  thickness: 0.5,
                ),

                Spacing.y(3),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<CloneVoiceProvider>(
                      builder: (context, provider, child) {
                        return Checkbox(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: provider.isAgreed,
                          onChanged: (val) {
                            provider.toggleAgreement(val!);
                          },
                        );
                      },
                    ),
                    Spacing.x(2),
                    Expanded(
                      child: Text(
                        "I accept the terms of recording and using my voice in stories generated by the Sleeping app",
                        style: textTheme.bodyMedium!.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: .6),
                        ),
                      ),
                    ),
                  ],
                ),
                Spacing.y(4),
                //
                Consumer<CloneVoiceProvider>(
                  builder: (context, value, child) => CustomButton(
                    isDisabled: !value.isAgreed,
                    text: "Next",
                    onPressed: () {
                      value.nextStep();
                    },
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          CustomButton(
            textColor: Theme.of(context).colorScheme.onSurface,
            buttonColor: context.appColors.lightGrey,
            text: "view sample voices",
            onPressed: () {
              // context.read<CloneVoiceProvider>().nextStep();
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SizedBox(
                    height: 200.h,
                    child: Column(children: []),
                  );
                },
              );
            },
          ),
          Spacing.y(1.5),
          TextButton(
            onPressed: () => context.read<CloneVoiceProvider>().nextStep(),
            child: Text(
              "Skip and create",
              style: textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordVoicePage extends StatelessWidget {
  const _RecordVoicePage();

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

class _VoiceCharacteristicsPage extends StatelessWidget {
  const _VoiceCharacteristicsPage();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final pitch = context.select<CloneVoiceProvider, double>((p) => p.pitch);
    final speed = context.select<CloneVoiceProvider, double>((p) => p.speed);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Voice Characteristics',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          Spacing.y(2.0),
          Text(
            'Pitch (${pitch.toStringAsFixed(2)})',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          Slider(
            value: pitch,
            min: 0.5,
            max: 2.0,
            onChanged: (value) =>
                context.read<CloneVoiceProvider>().updatePitch(value),
          ),
          Spacing.y(1.2),
          Text(
            'Speed (${speed.toStringAsFixed(2)})',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          Slider(
            value: speed,
            min: 0.5,
            max: 2.0,
            onChanged: (value) =>
                context.read<CloneVoiceProvider>().updateSpeed(value),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Back',
                  isOutlineButton: true,
                  onPressed: () =>
                      context.read<CloneVoiceProvider>().previousStep(),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: CustomButton(
                  text: 'Finish',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Voice cloning setup complete'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Spacing.y(1.5),
        ],
      ),
    );
  }
}
