import 'dart:async';
import 'dart:io';

import 'package:avatar_flow/core/debug/debug_point.dart';
import 'package:avatar_flow/core/services/voice_clone_service.dart';
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

  factory SampleVoice.fromElevenLabs(ElevenLabsVoice voice) {
    return SampleVoice(
      id: voice.voiceId,
      name: voice.name,
      tags: voice.labels,
      audioPath: voice.previewUrl ?? '',
      isNetwork: voice.previewUrl != null && voice.previewUrl!.isNotEmpty,
    );
  }
}

class SampleVoicesProvider extends ChangeNotifier {
  SampleVoicesProvider() {
    _playerStateSubscription = _player.playerStateStream.listen(
      _handlePlayerStateChanged,
    );
    // Fetch voices from ElevenLabs on init
    fetchVoicesFromElevenLabs();
  }

  final VoiceCloneService _voiceService = VoiceCloneService();

  // Static categories - All and Liked are first
  static const List<String> _staticCategories = ['All', 'Liked'];

  /// Dynamically generate categories from voice labels
  List<String> get categoryLabels {
    final allLabels = _voices.expand((v) => v.tags).toSet().toList()..sort();
    return [..._staticCategories, ...allLabels];
  }

  /// Static access for widget initialization
  static const String defaultCategory = 'All';

  List<SampleVoice> _voices = [];
  bool _isLoading = true;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  final AudioPlayer _player = AudioPlayer();
  final Set<String> _favoriteVoiceIds = {};

  StreamSubscription<PlayerState>? _playerStateSubscription;
  String _selectedCategory = 'All';
  String? _activeVoiceId;
  bool _isPlaying = false;

  String get selectedCategory => _selectedCategory;
  List<SampleVoice> get filteredVoices {
    if (_selectedCategory == 'All') {
      return _voices;
    }

    if (_selectedCategory == 'Liked') {
      return _voices.where((v) => _favoriteVoiceIds.contains(v.id)).toList();
    }

    return _voices
        .where((voice) => voice.tags.contains(_selectedCategory))
        .toList(growable: false);
  }

  /// Fetch voices from ElevenLabs API
  Future<void> fetchVoicesFromElevenLabs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Fetch favorites from DB first
      final favoriteIds = await _voiceService.fetchFavoriteVoiceIds();
      _favoriteVoiceIds.clear();
      _favoriteVoiceIds.addAll(favoriteIds);

      final elevenLabsVoices = await _voiceService.fetchVoices();

      if (elevenLabsVoices.isEmpty) {
        _error = 'No voices available';
        _voices = [];
      } else {
        _voices = elevenLabsVoices
            .where((v) => v.previewUrl != null && v.previewUrl!.isNotEmpty)
            .map((v) => SampleVoice.fromElevenLabs(v))
            .toList();
        DebugPoint.log(
          'Fetched ${_voices.length} voices from ElevenLabs with labels: ${categoryLabels.skip(2).toList()}',
        );
      }
    } catch (e) {
      _error = 'Failed to load voices: $e';
      DebugPoint.error('Error fetching voices: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Play TTS with default voice for preview
  Future<void> playDefaultVoice(String voiceId) async {
    try {
      if (_activeVoiceId == 'default_voice' && _isPlaying) {
        await _player.pause();
        return;
      }

      await _player.stop();
      _activeVoiceId = 'default_voice';
      _isPlaying = false;
      notifyListeners();

      // Use text-to-speech to generate audio with default voice
      final voiceService = VoiceCloneService();
      final audioBytes = await voiceService.textToSpeech(
        text: 'Hello, this is the default voice preview.',
        voiceId: voiceId,
      );

      if (audioBytes != null) {
        // Save to temp file and play
        final tempDir = await Directory.systemTemp.createTemp();
        final tempFile = File('${tempDir.path}/default_preview.mp3');
        await tempFile.writeAsBytes(audioBytes);
        await _player.setFilePath(tempFile.path);
        await _player.seek(Duration.zero);
        await _player.play();
      }
    } catch (error) {
      debugPrint('Default voice playback error: $error');
      _activeVoiceId = null;
      _isPlaying = false;
      notifyListeners();
    }
  }

  /// Play a voice by URL (for default voices that aren't in the list)
  Future<void> playVoiceByUrl(String voiceId, String url) async {
    try {
      if (_activeVoiceId == voiceId) {
        if (_isPlaying) {
          await _player.pause();
          return;
        }
        await _player.seek(Duration.zero);
        await _player.play();
        return;
      }

      await _player.stop();
      _activeVoiceId = voiceId;
      _isPlaying = false;
      notifyListeners();

      await _player.setUrl(url);
      await _player.seek(Duration.zero);
      await _player.play();
    } catch (error) {
      debugPrint('Voice playback error: $error');
      _activeVoiceId = null;
      _isPlaying = false;
      notifyListeners();
    }
  }

  void refreshVoices() {
    fetchVoicesFromElevenLabs();
  }

  bool isFavorite(String voiceId) => _favoriteVoiceIds.contains(voiceId);

  bool isPlaying(String voiceId) => _activeVoiceId == voiceId && _isPlaying;

  bool containsVoice(String voiceId) =>
      filteredVoices.any((voice) => voice.id == voiceId);

  String? get firstFilteredVoiceName =>
      filteredVoices.isEmpty ? null : filteredVoices.first.name;

  String? get firstFilteredVoiceId =>
      filteredVoices.isEmpty ? null : filteredVoices.first.id;

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
      _voiceService.removeFavoriteVoice(voiceId);
    } else {
      _favoriteVoiceIds.add(voiceId);
      _voiceService.addFavoriteVoice(voiceId);
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
