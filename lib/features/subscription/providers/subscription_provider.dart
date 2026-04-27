import 'package:flutter/material.dart';

class SubscriptionProvider extends ChangeNotifier {
  bool _isAnnual = true;
  bool _isLoading = false;

  bool get isAnnual => _isAnnual;
  bool get isLoading => _isLoading;

  void togglePlan(bool value) {
    if (_isAnnual != value) {
      _isAnnual = value;
      notifyListeners();
    }
  }

  void setIsAnnual(bool value) {
    _isAnnual = value;
    notifyListeners();
  }

  Future<void> subscribe() async {
    _isLoading = true;
    notifyListeners();

    // TODO: connect to payment provider
    await Future<void>.delayed(const Duration(milliseconds: 900));

    _isLoading = false;
    notifyListeners();
  }
}
