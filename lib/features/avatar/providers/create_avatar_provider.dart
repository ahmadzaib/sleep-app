import 'dart:async';
import 'dart:io';

import 'package:avatar_flow/core/config/appconfig.dart';
import 'package:avatar_flow/core/debug/debug_point.dart';
import 'package:avatar_flow/core/dio/dio_client.dart';
import 'package:avatar_flow/core/utils/toast_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class CreateAvatarProvider extends ChangeNotifier {
  // -------------------------
  // Avatar fields
  // -------------------------
  int currentIndex = 0;
  String avatarName = "Lilian";
  String selectedGender = "Female";
  List<String> traits = ["Adventurous", "Charismatic"];
  String selectedVoice = "Voice 1";
  String prompt = "";
  String? _avatarImagePath;
  String? get avatarImagePath => _avatarImagePath;
  bool _isCreating = false;

  bool get isCreating => _isCreating;

  void setAvatarImagePath(String? path) {
    _avatarImagePath = path;
    notifyListeners();
  }

  // -------------------------
  // Voice clone - step/page control
  // -------------------------
  final PageController voicePageController = PageController();
  int currentVoiceStep = 0;
  static const int totalVoiceSteps = 3;
  bool isAgreed = false;

  // -------------------------
  // Voice source selection
  // -------------------------
  static const String defaultVoiceId = 'default_voice';
  static const String defaultVoiceName = 'Default Voice';

  String? _selectedSampleVoiceId;
  String? get selectedSampleVoiceId => _selectedSampleVoiceId;

  bool get hasRecordedVoice => audioPath != null;
  bool get hasSampleVoice => _selectedSampleVoiceId != null;
  bool get isUsingDefaultVoice => !hasRecordedVoice && !hasSampleVoice;

  String get effectiveVoiceName {
    if (hasRecordedVoice) return voiceName.isNotEmpty ? voiceName : 'My Voice';
    if (hasSampleVoice) return _selectedSampleVoiceId!;
    return defaultVoiceName;
  }

  // -------------------------
  // Voice recording state
  // -------------------------
  bool isRecording = false;
  String? audioPath;
  String? transcript;
  Duration? voiceDuration;
  Duration recordingElapsed = Duration.zero;
  String voiceName = '';

  /// Select a sample voice (clears recorded voice)
  void selectSampleVoice(String voiceId) {
    _selectedSampleVoiceId = voiceId;
    // Clear recorded voice when sample is selected
    audioPath = null;
    voiceName = '';
    notifyListeners();
  }

  /// Clear sample voice selection
  void clearSampleVoice() {
    _selectedSampleVoiceId = null;
    notifyListeners();
  }

  /// Set recorded voice (clears sample selection)
  void setRecordedVoice(String path, {String? name}) {
    audioPath = path;
    if (name != null) voiceName = name;
    // Clear sample when recording is set
    _selectedSampleVoiceId = null;
    notifyListeners();
  }

  /// Use default voice (clears both)
  void useDefaultVoice() {
    audioPath = null;
    voiceName = '';
    _selectedSampleVoiceId = null;
    notifyListeners();
  }

  // -------------------------
  // Trait suggestions
  // -------------------------
  static const List<String> traitSuggestions = [
    'Adventurous',
    'Brave',
    'Bold',
    'Calm',
    'Charismatic',
    'Cheerful',
    'Curious',
    'Creative',
    'Fearless',
    'Friendly',
    'Kind',
    'Loyal',
    'Playful',
    'Smart',
    'Wise',
  ];

  final AudioRecorder _recorder = AudioRecorder();
  Timer? _recordingTimer;
  DateTime? _recordingStartAt;

  // -------------------------
  // Avatar field methods
  // -------------------------
  void changeIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void updateName(String name) {
    avatarName = name;
    notifyListeners();
  }

  void updateGender(String gender) {
    selectedGender = gender;
    notifyListeners();
  }

  void addTrait(String trait) {
    if (!traits.contains(trait)) {
      traits.add(trait);
      notifyListeners();
    }
  }

  void removeTrait(String trait) {
    traits.remove(trait);
    notifyListeners();
  }

  void toggleTrait(String trait) {
    if (traits.contains(trait)) {
      traits.remove(trait);
    } else {
      traits.add(trait);
    }
    notifyListeners();
  }

  void updateVoice(String voice) {
    selectedVoice = voice;
    selectSampleVoice(voice); // Use new method that handles mutual exclusion
  }

  void updatePrompt(String newPrompt) {
    prompt = newPrompt;
    notifyListeners();
  }

  // -------------------------
  // Voice clone step methods
  // -------------------------
  void nextVoiceStep() {
    if (currentVoiceStep < totalVoiceSteps - 1) {
      setVoiceStep(currentVoiceStep + 1);
    }
  }

  void previousVoiceStep() {
    if (currentVoiceStep > 0) {
      setVoiceStep(currentVoiceStep - 1);
    }
  }

  void setVoiceStep(int step) {
    if (step < 0 || step >= totalVoiceSteps || step == currentVoiceStep) return;
    currentVoiceStep = step;
    voicePageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }

  void toggleAgreement(bool val) {
    isAgreed = val;
    notifyListeners();
  }

  // -------------------------
  // Voice recording methods
  // -------------------------
  Future<void> startRecording() async {
    if (isRecording) return;

    final micGranted = await Permission.microphone.request();
    if (!micGranted.isGranted) return;

    final dir = await getTemporaryDirectory();
    final filePath =
        '${dir.path}/clone_voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000),
      path: filePath,
    );

    audioPath = null;
    transcript = null;
    voiceDuration = null;
    recordingElapsed = Duration.zero;
    isRecording = true;
    _recordingStartAt = DateTime.now();
    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      final start = _recordingStartAt;
      if (start == null) return;
      recordingElapsed = DateTime.now().difference(start);
      notifyListeners();
    });
    notifyListeners();
  }

  Future<void> stopRecording() async {
    if (!isRecording) return;

    final path = await _recorder.stop();
    _recordingTimer?.cancel();

    isRecording = false;
    _recordingStartAt = null;
    voiceDuration = recordingElapsed;
    if (voiceDuration == null || voiceDuration == Duration.zero) {
      voiceDuration = const Duration(seconds: 1);
    }
    transcript =
        'Your voice recording is ready. Tap play to preview or retake if needed.';

    // Use new method that handles mutual exclusion
    setRecordedVoice(path ?? '');
  }

  Future<void> retakeRecording() async {
    _recordingTimer?.cancel();
    if (isRecording) {
      await _recorder.stop();
    }

    isRecording = false;
    audioPath = null;
    voiceName = '';
    transcript = null;
    voiceDuration = null;
    recordingElapsed = Duration.zero;
    _recordingStartAt = null;
    // Note: We don't clear sample voice here, user can switch between them
    notifyListeners();
  }

  void updateVoiceName(String value) {
    voiceName = value.trim();
    notifyListeners();
  }

  // -------------------------
  // ElevenLabs API - Voice Cloning
  // -------------------------
  static String get _elevenLabsApiKey => AppConfig.elevenLabsApiKey;
  static String get _elevenLabsEndpoint =>
      '${AppConfig.elevenLabsEndpoint}/voices/add';

  /// Upload voice to ElevenLabs and get voice ID
  /// Returns voice ID based on source: recorded (cloned), sample (used as-is), or default
  Future<String?> getOrCreateVoiceId() async {
    // If using default voice, return default ID
    if (isUsingDefaultVoice) {
      DebugPoint.log('Using default voice: $defaultVoiceId');
      return defaultVoiceId;
    }

    // If using sample voice, return the sample voice ID
    if (hasSampleVoice) {
      DebugPoint.log('Using sample voice: $_selectedSampleVoiceId');
      return _selectedSampleVoiceId;
    }

    // If recorded voice, clone it to ElevenLabs
    if (hasRecordedVoice && audioPath != null) {
      try {
        // Check API key first
        DebugPoint.log(
          'ElevenLabs API Key configured: ${_elevenLabsApiKey.isNotEmpty}',
        );
        DebugPoint.log(
          'ElevenLabs API Key length: ${_elevenLabsApiKey.length}',
        );

        if (_elevenLabsApiKey.isEmpty) {
          ToastUtils.error(
            'ElevenLabs API key not configured. Check .env file',
          );
          return null;
        }

        ToastUtils.show('Cloning your voice with ElevenLabs...');
        DebugPoint.log('Cloning voice from file: ${audioPath!}');

        final dio = DioClient();
        final file = File(audioPath!);

        // Create multipart form data
        final formData = FormData.fromMap({
          'name': voiceName.isNotEmpty ? voiceName : avatarName,
          'description': 'Voice cloned for $avatarName',
          'files': await MultipartFile.fromFile(
            file.path,
            filename: 'voice_sample.mp3',
          ),
        });

        final response = await dio.dio.post(
          _elevenLabsEndpoint,
          data: formData,
          options: Options(headers: {'xi-api-key': _elevenLabsApiKey}),
        );

        DebugPoint.log('ElevenLabs Response status: ${response.statusCode}');
        DebugPoint.debug('Response data: ${response.data}');

        if (response.statusCode == 200) {
          final voiceId = response.data['voice_id'];
          DebugPoint.log('Voice cloned successfully! ID: $voiceId');
          ToastUtils.success('Voice cloned successfully!');
          return voiceId;
        } else {
          DebugPoint.error('Failed to clone voice: ${response.statusCode}');
          ToastUtils.error('Failed to clone voice: ${response.statusCode}');
          return null;
        }
      } catch (e) {
        DebugPoint.error('ElevenLabs API Error: $e');
        ToastUtils.error('ElevenLabs API Error: $e');
        return null;
      }
    }

    return null;
  }

  // -------------------------
  // Create avatar with voice
  // -------------------------
  Future<void> createAvatar() async {
    DebugPoint.log('Creating avatar...');
    DebugPoint.log('Avatar name: $avatarName');
    DebugPoint.log('Avatar image path: $avatarImagePath');
    DebugPoint.log(
      'Voice source: ${hasRecordedVoice
          ? "recorded"
          : hasSampleVoice
          ? "sample"
          : "default"}',
    );

    if (avatarName.trim().isEmpty) {
      ToastUtils.error('Please enter a name for your avatar');
      return;
    }

    _isCreating = true;
    notifyListeners();

    // Get voice ID based on selected source (recorded/sample/default)
    String? voiceId = await getOrCreateVoiceId();
    DebugPoint.log('Voice ID result: $voiceId');

    try {
      // For now, store locally. Later: save to backend with voiceId
      ToastUtils.success('Avatar created! Voice ID: $voiceId');
      DebugPoint.log('Avatar created with voice ID: $voiceId');
    } catch (e) {
      ToastUtils.error('Failed to create avatar: $e');
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _recorder.dispose();
    voicePageController.dispose();
    super.dispose();
  }
}
