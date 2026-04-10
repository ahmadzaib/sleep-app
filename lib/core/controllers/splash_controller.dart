import 'package:flutter/material.dart';

class SplashController extends ChangeNotifier {
  bool _isInitialized = false;
  bool _isLoading = true;
  
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;

  Future<void> initializeSplash() async {
    // Simulate splash screen duration and any initialization
    await Future.delayed(const Duration(seconds: 3));
    
    _isLoading = false;
    _isInitialized = true;
    notifyListeners();
  }

  void skipSplash() {
    if (_isLoading) {
      _isLoading = false;
      _isInitialized = true;
      notifyListeners();
    }
  }
}
