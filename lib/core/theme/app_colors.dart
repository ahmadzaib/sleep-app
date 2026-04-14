import 'package:flutter/material.dart';

class AppColors {
  // Primary Purple (kept strong brand identity)
  static const primary100 = Color(0xFF7C4DFF); // slightly softer than #843DFB

  // Greyscale (kept clean & modern)
  static const grey100 = Color(0xFF000000);
  static const grey200 = Color(0xFF1F1F1F); // deeper dark text
  static const grey300 = Color(0xFF6E6E6E); // muted text (matches UI better)
  static const grey400 = Color(0xFFEDEDED); // borders
  static const grey500 = Color(0xFFF5F5F5); // light dividers
  static const grey600 = Color(0xFFFAFAFA);
  static const grey700 = Color(0xFFFFFFFF);

  // Backgrounds (from your UI image)
  static const lightBg = Color(0xFFFFFFFF);
  static const darkBg = Color(0xFF121212);

  // Soft surfaces (cards feel slightly warm in your design)
  static const lightSurface = Color(0xFFFFFBFF);
  static const darkSurface = Color(0xFF262626);

  // Message colors
  static const message100 = Color(0xFF2FB344); // green success
  static const message200 = Color(0xFFEE2222); // soft red error

  // Gradient background (key match from your design)
  static const bgGradient1 = Color(0xFFFFE6D6); // warm peach
  static const bgGradient2 = Color(0xFFF3D9FF); // soft lavender

  // Compatibility aliases
  static const primaryColor = primary100;
  static const secondaryColor = Color(0xFF2E2636);
  static const blue = Color(0xFF048FF2);
  static const backgroundColor = lightBg;
  static const secondaryBlack900 = grey200;
  static const primaryTextColor = grey200;
  static const blackColor = grey100;
  static const whiteColor = grey700;

  // Status
  static const success = message100;
  static const error = message200;
  static const requiredRedColor = message200;
  static const textFieldValidationRedColor = message200;
}
