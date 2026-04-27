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
  // Voice recording state
  // -------------------------
  bool isRecording = false;
  String? audioPath;
  String? transcript;
  Duration? voiceDuration;
  Duration recordingElapsed = Duration.zero;
  String voiceName = '';

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
    notifyListeners();
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
    audioPath = path;
    voiceDuration = recordingElapsed;
    if (voiceDuration == null || voiceDuration == Duration.zero) {
      voiceDuration = const Duration(seconds: 1);
    }
    transcript =
        'Your voice recording is ready. Tap play to preview or retake if needed.';
    notifyListeners();
  }

  Future<void> retakeRecording() async {
    _recordingTimer?.cancel();
    if (isRecording) {
      await _recorder.stop();
    }

    isRecording = false;
    audioPath = null;
    transcript = null;
    voiceDuration = null;
    recordingElapsed = Duration.zero;
    _recordingStartAt = null;
    notifyListeners();
  }

  void updateVoiceName(String value) {
    voiceName = value.trim();
    notifyListeners();
  }

  // -------------------------
  // ElevenLabs API - Voice Cloning
  // -------------------------
  static const String _elevenLabsApiKey = AppConfig.elevenLabsApiKey;
  static const String _elevenLabsEndpoint =
      '${AppConfig.elevenLabsEndpoint}/voices/add';

  /// Upload voice to ElevenLabs and get voice ID
  Future<String?> cloneVoiceToElevenLabs() async {
    if (audioPath == null) {
      ToastUtils.error('No voice recording found');
      return null;
    }

    try {
      ToastUtils.show('Cloning voice with ElevenLabs...');

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

      if (response.statusCode == 200) {
        final voiceId = response.data['voice_id'];
        ToastUtils.success('Voice cloned successfully!');
        return voiceId;
      } else {
        ToastUtils.error('Failed to clone voice: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      ToastUtils.error('ElevenLabs API Error: $e');
      return null;
    }
  }

  // -------------------------
  // Create avatar with voice
  // -------------------------
  Future<void> createAvatar() async {
    if (avatarName.trim().isEmpty) {
      ToastUtils.error('Please enter a name for your avatar');
      return;
    }

    _isCreating = true;
    notifyListeners();

    // Clone voice to ElevenLabs if we have a recording
    String? voiceId;
    if (audioPath != null && isAgreed) {
      voiceId = await cloneVoiceToElevenLabs();
    }

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
