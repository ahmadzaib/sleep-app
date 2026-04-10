import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Supports percentage-based spacing using ScreenUtil to avoid context dependency.
class Spacing {
  /// Horizontal spacing in percentage of screen width (0-100)
  static Widget x(double percent) => SizedBox(width: percent.sw*0.01);

  /// Vertical spacing in percentage of screen height (0-100)
  static Widget y(double percent) => SizedBox(height: percent.sh*0.01);
}
