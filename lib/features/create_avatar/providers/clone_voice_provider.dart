import 'package:flutter/material.dart';

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

  void startRecording() {
    if (isRecording) return;
    isRecording = true;
    notifyListeners();
  }

  void stopRecording() {
    if (!isRecording) return;
    isRecording = false;
    audioPath = 'recordings/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
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
    pageController.dispose();
    super.dispose();
  }
}
