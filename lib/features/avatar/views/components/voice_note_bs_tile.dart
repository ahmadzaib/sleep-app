import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

class VoiceNoteBSTile extends StatefulWidget {
  final String title;
  final String audioPath;
  final bool isNetwork;
  final bool isFile;

  const VoiceNoteBSTile({
    super.key,
    required this.title,
    required this.audioPath,
    this.isNetwork = false,
    this.isFile = false,
  });

  @override
  State<VoiceNoteBSTile> createState() => _VoiceNoteBSTileState();
}

class _VoiceNoteBSTileState extends State<VoiceNoteBSTile> {
  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    /// Listen once for completion
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() => isPlaying = false);
      }
    });

    /// Preload audio (no loader UI needed)
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      if (widget.isNetwork) {
        await _player.setUrl(widget.audioPath);
      } else if (widget.isFile) {
        await _player.setFilePath(widget.audioPath);
      } else {
        await _player.setAsset(widget.audioPath);
      }
    } catch (e) {
      debugPrint("Audio init error: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    try {
      if (isPlaying) {
        await _player.pause();
        setState(() => isPlaying = false);
      } else {
        /// Always restart from beginning
        await _player.seek(Duration.zero);
        setState(() => isPlaying = true);
        await _player.play();
      }
    } catch (e) {
      debugPrint("Audio error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: AppConstants.defaultPaddingHorizental,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.smallRadius),
        boxShadow: [AppConstants.defaultShadow],
      ),
      child: Row(
        children: [
          /// Icon
          CustomSvg(
            path: AppIconsSvg.speaking,
            color: context.appColors.grey,
            size: 20,
          ),

          Spacing.x(3),

          /// Title
          Text(
            widget.title,
            style: textTheme.bodyMedium!.copyWith(
              color: context.appColors.grey,
            ),
          ),

          const Spacer(),

          /// Static Waveform
          Row(
            children: List.generate(
              10,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 1.w),
                width: 2.w,
                height: (index % 3 + 1) * 4.h,
                decoration: BoxDecoration(
                  color: context.appColors.grey.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
          ),

          Spacing.x(3),

          /// Play / Pause Button
          IconButton(
            onPressed: _togglePlay,
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: context.appColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
