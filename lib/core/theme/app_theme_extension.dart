import 'package:flutter/material.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color primary;
  final Color secondary;
  final Color grey;
  final Color lightGrey;
  final Color success;
  final Color error;
  final Color secondaryBlack;
  final Color bubbleGray;
  final Color iconColor;
  final Color bgGradient1;
  final Color bgGradient2;
  final Color blue;

  const AppColorsExtension({
    required this.primary,
    required this.secondary,
    required this.grey,
    required this.lightGrey,
    required this.success,
    required this.error,
    required this.secondaryBlack,
    required this.bubbleGray,
    required this.iconColor,
    required this.bgGradient1,
    required this.bgGradient2,
    required this.blue,
  });

  @override
  AppColorsExtension copyWith({
    Color? primary,
    Color? secondary,
    Color? grey,
    Color? lightGrey,
    Color? success,
    Color? error,
    Color? secondaryBlack,
    Color? bubbleGray,
    Color? iconColor,
    Color? bgGradient1,
    Color? bgGradient2,
    Color? blue,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      grey: grey ?? this.grey,
      lightGrey: lightGrey ?? this.lightGrey,
      success: success ?? this.success,
      error: error ?? this.error,
      secondaryBlack: secondaryBlack ?? this.secondaryBlack,
      bubbleGray: bubbleGray ?? this.bubbleGray,
      iconColor: iconColor ?? this.iconColor,
      bgGradient1: bgGradient1 ?? this.bgGradient1,
      bgGradient2: bgGradient2 ?? this.bgGradient2,
      blue: blue ?? this.blue,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      grey: Color.lerp(grey, other.grey, t)!,
      lightGrey: Color.lerp(lightGrey, other.lightGrey, t)!,
      success: Color.lerp(success, other.success, t)!,
      error: Color.lerp(error, other.error, t)!,
      secondaryBlack: Color.lerp(secondaryBlack, other.secondaryBlack, t)!,
      bubbleGray: Color.lerp(bubbleGray, other.bubbleGray, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      bgGradient1: Color.lerp(bgGradient1, other.bgGradient1, t)!,
      bgGradient2: Color.lerp(bgGradient2, other.bgGradient2, t)!,
      blue: Color.lerp(blue, other.blue, t)!,
    );
  }
}

extension AppThemeContext on BuildContext {
  AppColorsExtension get appColors =>
      Theme.of(this).extension<AppColorsExtension>()!;
}
