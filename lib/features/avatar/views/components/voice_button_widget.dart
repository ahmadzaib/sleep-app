import 'dart:io';

import 'package:avatar_flow/core/services/voice_clone_service.dart';
import 'package:avatar_flow/widgets/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class VoicePlayButton extends StatefulWidget {
  final String source; // asset path OR url
  final bool isAsset;

  final Color? backgroundColor;
  final Color? iconColor;
  final String label;

  const VoicePlayButton({
    super.key,
    required this.source,
    this.isAsset = false,
    this.backgroundColor,
    this.iconColor,
    this.label = "Voice",
  });

  @override
  State<VoicePlayButton> createState() => _VoicePlayButtonState();
}

/// Voice TTS Button - generates text-to-speech using ElevenLabs voice_id
class VoiceTTSButton extends StatefulWidget {
  final String? voiceId;
  final String text;
  final Color? backgroundColor;
  final Color? iconColor;
  final String label;

  const VoiceTTSButton({
    super.key,
    this.voiceId,
    required this.text,
    this.backgroundColor,
    this.iconColor,
    this.label = "Voice",
  });

  @override
  State<VoiceTTSButton> createState() => _VoiceTTSButtonState();
}

class _VoicePlayButtonState extends State<VoicePlayButton> {
  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;

  Future<void> _initAndPlay() async {
    try {
      if (widget.isAsset) {
        await _player.setAsset(widget.source);
      } else {
        await _player.setUrl(widget.source);
      }

      setState(() => isPlaying = true);
      await _player.play();

      _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() => isPlaying = false);
        }
      });
    } catch (e) {
      debugPrint("Audio error: $e");
    }
  }

  Future<void> _toggle() async {
    if (isPlaying) {
      await _player.pause();
      setState(() => isPlaying = false);
    } else {
      await _initAndPlay();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.backgroundColor ?? Theme.of(context).colorScheme.surface;
    final iconC = widget.iconColor ?? Theme.of(context).colorScheme.onSurface;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: _toggle,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: iconC,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall!.copyWith(color: iconC),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VoiceTTSButtonState extends State<VoiceTTSButton> {
  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;
  bool isLoading = false;
  String? _tempAudioPath;

  Future<void> _generateAndPlay() async {
    if (widget.voiceId == null || widget.voiceId!.isEmpty) {
      debugPrint("No voice_id available for TTS");
      return;
    }

    setState(() => isLoading = true);

    try {
      // Generate TTS using VoiceCloneService
      final voiceService = VoiceCloneService();
      final audioBytes = await voiceService.textToSpeech(
        voiceId: widget.voiceId!,
        text: widget.text,
      );

      if (audioBytes == null) {
        debugPrint("Failed to generate TTS audio");
        setState(() => isLoading = false);
        return;
      }

      // Save to temp file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
        '${tempDir.path}/tts_${DateTime.now().millisecondsSinceEpoch}.mp3',
      );
      await tempFile.writeAsBytes(audioBytes);
      _tempAudioPath = tempFile.path;

      // Play the audio
      await _player.setFilePath(_tempAudioPath!);
      setState(() {
        isLoading = false;
        isPlaying = true;
      });
      await _player.play();

      _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() => isPlaying = false);
        }
      });
    } catch (e) {
      debugPrint("TTS error: $e");
      setState(() {
        isLoading = false;
        isPlaying = false;
      });
    }
  }

  Future<void> _toggle() async {
    if (isPlaying) {
      await _player.pause();
      setState(() => isPlaying = false);
    } else if (_tempAudioPath != null) {
      // Reuse existing audio
      try {
        await _player.setFilePath(_tempAudioPath!);
        setState(() => isPlaying = true);
        await _player.play();
      } catch (e) {
        debugPrint("Replay error: $e");
        await _generateAndPlay();
      }
    } else {
      await _generateAndPlay();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    // Clean up temp file
    if (_tempAudioPath != null) {
      try {
        File(_tempAudioPath!).deleteSync();
      } catch (e) {
        debugPrint("Failed to delete temp audio: $e");
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.backgroundColor ?? Theme.of(context).colorScheme.surface;
    final iconC = widget.iconColor ?? Theme.of(context).colorScheme.onSurface;
    final disabled = widget.voiceId == null || widget.voiceId!.isEmpty;

    return Material(
      color: disabled ? Colors.grey.withOpacity(0.3) : bg,
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: disabled ? null : _toggle,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                SizedBox(width: 18, height: 18, child: AppLoading())
              else
                Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: disabled ? Colors.grey : iconC,
                  size: 18,
                ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: disabled ? Colors.grey : iconC,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
