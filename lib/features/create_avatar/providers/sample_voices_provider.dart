import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class SampleVoice {
  final String id;
  final String name;
  final List<String> tags;
  final String audioPath;
  final bool isNetwork;

  const SampleVoice({
    required this.id,
    required this.name,
    required this.tags,
    required this.audioPath,
    this.isNetwork = false,
  });
}

class SampleVoicesProvider extends ChangeNotifier {
  SampleVoicesProvider() {
    _playerStateSubscription = _player.playerStateStream.listen(
      _handlePlayerStateChanged,
    );
  }

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

  static const List<SampleVoice> _voices = [
    SampleVoice(
      id: 'voice_1',
      name: 'Voice 1',
      tags: ['Man', 'Serious', 'Deep'],
      audioPath: 'assets/audio/music.mp3',
    ),
    SampleVoice(
      id: 'voice_2',
      name: 'Voice 2',
      tags: ['Woman', 'Calm', 'Random'],
      audioPath: 'assets/audio/music.mp3',
    ),
    SampleVoice(
      id: 'voice_3',
      name: 'Voice 3',
      tags: ['Excited', 'Random'],
      audioPath: 'assets/audio/music.mp3',
    ),
  ];

  final AudioPlayer _player = AudioPlayer();
  final Set<String> _favoriteVoiceIds = {};

  StreamSubscription<PlayerState>? _playerStateSubscription;
  String _selectedCategory = categoryLabels.first;
  String? _activeVoiceId;
  bool _isPlaying = false;

  String get selectedCategory => _selectedCategory;
  List<SampleVoice> get filteredVoices {
    if (_selectedCategory == categoryLabels.first) {
      return _voices;
    }

    return _voices
        .where((voice) => voice.tags.contains(_selectedCategory))
        .toList(growable: false);
  }

  bool isFavorite(String voiceId) => _favoriteVoiceIds.contains(voiceId);

  bool isPlaying(String voiceId) => _activeVoiceId == voiceId && _isPlaying;

  bool containsVoice(String voiceName) =>
      filteredVoices.any((voice) => voice.name == voiceName);

  String? get firstFilteredVoiceName =>
      filteredVoices.isEmpty ? null : filteredVoices.first.name;

  void selectCategory(String category) {
    if (_selectedCategory == category) {
      return;
    }

    _selectedCategory = category;

    final activeVoiceStillVisible = filteredVoices.any(
      (voice) => voice.id == _activeVoiceId,
    );
    if (!activeVoiceStillVisible) {
      _activeVoiceId = null;
      _isPlaying = false;
      unawaited(_player.stop());
    }

    notifyListeners();
  }

  void toggleFavorite(String voiceId) {
    if (_favoriteVoiceIds.contains(voiceId)) {
      _favoriteVoiceIds.remove(voiceId);
    } else {
      _favoriteVoiceIds.add(voiceId);
    }

    notifyListeners();
  }

  Future<void> togglePlayback(SampleVoice voice) async {
    try {
      if (_activeVoiceId == voice.id) {
        if (_isPlaying) {
          await _player.pause();
          return;
        }

        await _player.seek(Duration.zero);
        await _player.play();
        return;
      }

      await _player.stop();
      _activeVoiceId = voice.id;
      _isPlaying = false;
      notifyListeners();

      if (voice.isNetwork) {
        await _player.setUrl(voice.audioPath);
      } else {
        await _player.setAsset(voice.audioPath);
      }

      await _player.seek(Duration.zero);
      await _player.play();
    } catch (error) {
      debugPrint('Sample voice audio error: $error');
      _activeVoiceId = null;
      _isPlaying = false;
      notifyListeners();
    }
  }

  void _handlePlayerStateChanged(PlayerState state) {
    final completed = state.processingState == ProcessingState.completed;
    final nextIsPlaying = !completed && state.playing;

    if (completed) {
      _activeVoiceId = null;
    }

    if (_isPlaying == nextIsPlaying && !completed) {
      return;
    }

    _isPlaying = nextIsPlaying;
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_playerStateSubscription?.cancel());
    unawaited(_player.dispose());
    super.dispose();
  }
}
