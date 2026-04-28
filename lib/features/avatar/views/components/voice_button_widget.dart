import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

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
