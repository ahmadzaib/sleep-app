import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';

class AppConstants {
  AppConstants._();

  static Duration pageTransitionDuration = const Duration(milliseconds: 300);
  static Duration defaultDuration = const Duration(milliseconds: 300);
  static Duration bannerDuration = const Duration(milliseconds: 800);

  static double profilePhotoRadius = 100.r;

  static double largeRadius = 24.r;
  static double mediumRadius = 18.r;
  static double smallRadius = 12.r;
  static double extraLargeRadius = 36.r;
  static double circleRadius = 50.r;

  static double paddingOnly = 12.w;

  static final EdgeInsets defaultPaddingHorizental = EdgeInsets.symmetric(
    horizontal: paddingOnly,
  );

  static final EdgeInsets defaultAllPadding = EdgeInsets.all(paddingOnly);

  // TILE BORDER - Instagram style
  static Border tileBorder(BuildContext context) => Border.all(
    color: Theme.of(context).brightness == Brightness.light
        ? context.appColors.lightGrey
        : context.appColors.bubbleGray,
    width: 0.8.r,
  );

  // GRADIENTS - now use theme colors
  static LinearGradient defaultGradient(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [context.appColors.bgGradient1, context.appColors.bgGradient2],
  );

  // Chip Styling
  static double chipRadius = 20.r;
  static EdgeInsets chipPadding = EdgeInsets.symmetric(
    horizontal: 16.w,
    vertical: 6.h,
  );

  // Default Shadow
  static BoxShadow defaultShadow = BoxShadow(
    color: Colors.black.withValues(alpha: 0.1),
    blurRadius: 10.r,
    offset: Offset(0, 5),
  );
}
