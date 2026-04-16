import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class CloneVoiceProvider extends ChangeNotifier {
  bool isAgreed = false;
  // -------------------------
  // Step/Page control
  // -------------------------
  final PageController pageController = PageController();
  int currentStep = 0;
  static const int totalSteps = 3;

  void nextStep() {
    if (currentStep < totalSteps - 1) {
      setStep(currentStep + 1);
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setStep(currentStep - 1);
    }
  }

  void toggleAgreement(bool val) {
    isAgreed = val;
    notifyListeners();
  }

  void setStep(int step) {
    if (step < 0 || step >= totalSteps || step == currentStep) return;
    currentStep = step;
    pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
    notifyListeners();
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

  // -------------------------
  // Character characteristics
  // -------------------------
  final List<String> traits = [];

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

  void toggleTrait(String trait) {
    if (traits.contains(trait)) {
      traits.remove(trait);
    } else {
      traits.add(trait);
    }
    notifyListeners();
  }

  final AudioRecorder _recorder = AudioRecorder();
  Timer? _recordingTimer;
  DateTime? _recordingStartAt;

  CloneVoiceProvider();

  Future<void> startRecording() async {
    if (isRecording) {
      return;
    }

    final micGranted = await Permission.microphone.request();
    if (!micGranted.isGranted) {
      return;
    }

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
    if (!isRecording) {
      return;
    }

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

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _recorder.dispose();
    pageController.dispose();
    super.dispose();
  }
}
