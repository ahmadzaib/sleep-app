import 'package:flutter/material.dart';

class SubscriptionProvider extends ChangeNotifier {
  bool _isAnnual = true;

  bool get isAnnual => _isAnnual;

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
}
