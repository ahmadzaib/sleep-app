import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/avatar/providers/create_avatar_provider.dart';
import 'package:avatar_flow/features/avatar/views/components/sample_voices_bottom_sheet.dart';
import 'package:avatar_flow/widgets/circled_icon_widget.dart';
import 'package:avatar_flow/widgets/custom_button.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:avatar_flow/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class RecordVoicePage extends StatefulWidget {
  const RecordVoicePage({super.key});

  @override
  State<RecordVoicePage> createState() => _RecordVoicePageState();
}

class _RecordVoicePageState extends State<RecordVoicePage> {
  final TextEditingController _voiceNameController = TextEditingController();
  final FocusNode _voiceNameFocusNode = FocusNode();
  final AudioPlayer _player = AudioPlayer();
  bool _isEditingVoiceName = false;
  bool _isPlaying = false;
  String? _loadedAudioPath;

  @override
  void initState() {
    super.initState();
    _voiceNameFocusNode.addListener(() {
      if (!_voiceNameFocusNode.hasFocus && _isEditingVoiceName && mounted) {
        final provider = context.read<CreateAvatarProvider>();
        _finishVoiceNameEditing(provider);
      }
    });
    _player.playerStateStream.listen((state) {
      if (!mounted) return;

      final isActive =
          state.playing &&
          state.processingState != ProcessingState.completed &&
          state.processingState != ProcessingState.idle;

      if (_isPlaying != isActive) {
        setState(() {
          _isPlaying = isActive;
        });
      }
    });
  }

  @override
  void dispose() {
    _voiceNameController.dispose();
    _voiceNameFocusNode.dispose();
    _player.dispose();
    super.dispose();
  }

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
      child: Consumer<CreateAvatarProvider>(
        builder: (context, provider, _) {
          final isRecording = provider.isRecording;
          final hasRecording = provider.audioPath != null;
          final transcript = provider.transcript;
          final voiceDuration = provider.voiceDuration;
          final recordingElapsed = provider.recordingElapsed;
          final voiceName = provider.effectiveVoiceName;
          final hasSampleVoice = provider.hasSampleVoice;

          if (!hasRecording && _loadedAudioPath != null) {
            _loadedAudioPath = null;
            _player.stop();
            _isPlaying = false;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Voice Source Indicator
              _buildVoiceSourceChip(context, provider),
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
                      child: _isEditingVoiceName
                          ? SizedBox(
                              width: 1.sw,
                              child: CustomTextField(
                                controller: _voiceNameController,
                                focusNode: _voiceNameFocusNode,
                                hintText: "Name of voice",
                                borderColor: Colors.transparent,
                                fillColor: Colors.transparent,
                                contentPadding: EdgeInsets.zero,
                                textfieldBorderRadius: AppConstants.smallRadius,
                                onChanged: (value) {
                                  provider.updateVoiceName(value ?? "");
                                  return null;
                                },
                                onFieldSubmitted: (_) =>
                                    _finishVoiceNameEditing(provider),
                              ),
                            )
                          : InkWell(
                              onTap: () => _startVoiceNameEditing(provider),
                              child: Text(
                                voiceName,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
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
                    if (hasRecording) ...[
                      IconButton(
                        onPressed: () async {
                          await _togglePlayback(provider.audioPath!);
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: context.appColors.primary.withValues(
                            alpha: 0.12,
                          ),
                          minimumSize: Size(52.w, 52.w),
                        ),
                        icon: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: context.appColors.primary,
                          size: 28.sp,
                        ),
                      ),
                      Spacing.y(1.2),
                      TextButton(
                        onPressed: () async => provider.retakeRecording(),
                        child: Text(
                          "Retake voice",
                          style: textTheme.bodyMedium?.copyWith(
                            color: context.appColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ] else ...[
                      Spacing.y(1),
                      CustomButton(
                        text: isRecording ? 'Stop' : 'Start Recording',
                        onPressed: () async {
                          if (isRecording) {
                            await provider.stopRecording();
                          } else {
                            await provider.startRecording();
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ),
              Spacer(),
              // Option buttons when no recording
              if (!hasRecording && !isRecording) ...[
                TextButton(
                  onPressed: () => _showSampleVoices(context),
                  child: Text(
                    "Choose from samples",
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: context.appColors.primary,
                    ),
                  ),
                ),

                Spacing.y(1.2),
              ],
              CustomButton(
                text:
                    'Continue with ${provider.effectiveVoiceName.split("-").first}',
                isDisabled:
                    isRecording ||
                    (!hasRecording &&
                        !hasSampleVoice &&
                        !provider.isUsingDefaultVoice),
                onPressed: isRecording ? null : () => provider.nextVoiceStep(),
              ),
              Spacing.y(1.2),
              TextButton(
                onPressed: isRecording
                    ? null
                    : () {
                        provider.setVoiceStep(2);
                      },
                child: Text(
                  "Skip voice and continue",
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

  void _startVoiceNameEditing(CreateAvatarProvider provider) {
    _voiceNameController
      ..text = provider.voiceName
      ..selection = TextSelection.collapsed(offset: provider.voiceName.length);

    setState(() {
      _isEditingVoiceName = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _voiceNameFocusNode.requestFocus();
      }
    });
  }

  void _finishVoiceNameEditing(CreateAvatarProvider provider) {
    provider.updateVoiceName(_voiceNameController.text);

    if (mounted) {
      setState(() {
        _isEditingVoiceName = false;
      });
    }
  }

  Future<void> _togglePlayback(String audioPath) async {
    try {
      if (_loadedAudioPath != audioPath) {
        await _player.setFilePath(audioPath);
        _loadedAudioPath = audioPath;
      }

      if (_player.playing) {
        await _player.pause();
        if (mounted) {
          setState(() {
            _isPlaying = false;
          });
        }
      } else {
        if (_player.processingState == ProcessingState.completed) {
          await _player.seek(Duration.zero);
        }
        if (mounted) {
          setState(() {
            _isPlaying = true;
          });
        }
        await _player.play();
      }
    } catch (e) {
      debugPrint('Audio playback error: $e');
    }
  }

  /// Show sample voices bottom sheet
  void _showSampleVoices(BuildContext context) {
    SampleVoicesBottomSheet.show(context);
  }

  /// Build voice source indicator chip
  Widget _buildVoiceSourceChip(
    BuildContext context,
    CreateAvatarProvider provider,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final isUsingDefault = provider.isUsingDefaultVoice;
    final hasSample = provider.hasSampleVoice;
    final hasRecorded = provider.hasRecordedVoice;

    String label;
    IconData icon;
    Color color;

    if (hasRecorded) {
      label = 'Your Recorded Voice';
      icon = Icons.mic;
      color = context.appColors.primary;
    } else if (hasSample) {
      label = 'Voice: ${provider.effectiveVoiceName.split("-").first}';
      icon = Icons.headphones;
      color = context.appColors.secondary;
    } else {
      label = 'Default Voice';
      icon = Icons.volume_up;
      color = context.appColors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 8.w),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (!isUsingDefault) ...[
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: () {
                // Clear current selection and use default
                provider.useDefaultVoice();
              },
              child: Icon(Icons.close, size: 14, color: color),
            ),
          ],
        ],
      ),
    );
  }
}
