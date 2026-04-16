import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:flutter_tts/flutter_tts.dart';

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
  bool isPlaying = false;
  Duration recordingElapsed = Duration.zero;

  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  final FlutterTts _tts = FlutterTts();
  Timer? _recordingTimer;
  DateTime? _recordingStartAt;
  StreamSubscription<PlayerState>? _playerStateSub;

  CloneVoiceProvider() {
    _playerStateSub = _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed && isPlaying) {
        isPlaying = false;
        notifyListeners();
      }
    });
  }

  Future<void> startRecording() async {
    if (isRecording) {
      return;
    }

    final micGranted = await Permission.microphone.request();
    if (!micGranted.isGranted) {
      return;
    }

    if (isPlaying) {
      await _player.stop();
      isPlaying = false;
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
    isPlaying = false;
    notifyListeners();

    await _tts.stop();
    await _tts.speak(transcript!);
  }

  Future<void> togglePlayback() async {
    final path = audioPath;
    if (path == null || isRecording) {
      return;
    }

    if (isPlaying) {
      await _player.pause();
      isPlaying = false;
      notifyListeners();
      return;
    }

    final file = File(path);
    if (!await file.exists()) {
      return;
    }

    await _player.setFilePath(path);
    await _player.seek(Duration.zero);
    await _player.play();
    isPlaying = true;
    notifyListeners();
  }

  Future<void> retakeRecording() async {
    _recordingTimer?.cancel();
    if (isRecording) {
      await _recorder.stop();
    }
    if (isPlaying) {
      await _player.stop();
    }

    isRecording = false;
    isPlaying = false;
    audioPath = null;
    transcript = null;
    voiceDuration = null;
    recordingElapsed = Duration.zero;
    _recordingStartAt = null;
    notifyListeners();
  }

  // -------------------------
  // Voice characteristics
  // -------------------------
  double pitch = 1.0;
  double speed = 1.0;

  void updatePitch(double value) {
    if (pitch == value) return;
    pitch = value;
    notifyListeners();
  }

  void updateSpeed(double value) {
    if (speed == value) return;
    speed = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _playerStateSub?.cancel();
    _recorder.dispose();
    _player.dispose();
    pageController.dispose();
    super.dispose();
  }
}
