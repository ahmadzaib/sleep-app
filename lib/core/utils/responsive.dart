import 'package:flutter/material.dart';

class Responsive {
  // Get device width percentage
  static double width(double size, BuildContext context) {
    return MediaQuery.sizeOf(context).width * (size / 100);
  }

  // Get device height percentage
  static double height(double size, BuildContext context) {
    return MediaQuery.sizeOf(context).height * (size / 100);
  }
}
