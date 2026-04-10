import 'package:flutter/material.dart';
import 'package:avatar_flow/core/constants/keys.dart';
import 'package:avatar_flow/core/services/preferences.dart';

class ThemeController extends ChangeNotifier {
  final Preferences prefs;

  ThemeController(this.prefs);

  ThemeMode _currentTheme = ThemeMode.light;
  ThemeMode get currentTheme => _currentTheme;

  /// Load saved theme from preferences
  void loadTheme() {
    final isDark = prefs.getBool(Keys.isDarkMode) ?? false;

    _currentTheme = isDark ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }

  void toggleTheme() async {
    final isDark = _currentTheme == ThemeMode.light;

    _currentTheme = isDark ? ThemeMode.dark : ThemeMode.light;

    await prefs.setBool(Keys.isDarkMode, isDark);

    notifyListeners();
  }
}