import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/theme/app_colors.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    fontFamily: GoogleFonts.lexend().fontFamily,
    canvasColor: AppColors.lightBg,
    scaffoldBackgroundColor: AppColors.lightBg,
    useMaterial3: true,
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightBg,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.grey200),
      titleTextStyle: GoogleFonts.lexend(
        color: AppColors.grey200,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStatePropertyAll(AppColors.primaryColor),
      overlayColor: WidgetStatePropertyAll(AppColors.requiredRedColor),
    ),
    iconTheme: const IconThemeData(color: AppColors.grey200),
    cardColor: AppColors.lightSurface,
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.whiteColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.largeRadius),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.whiteColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      modalElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.extraLargeRadius),
        ),
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      onPrimary: AppColors.whiteColor,
      secondary: AppColors.grey500,
      surface: AppColors.lightBg,
      onSurface: AppColors.grey200,
      inversePrimary: AppColors.whiteColor,
      error: AppColors.error,
      onError: AppColors.error,
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.lightBg,
      thickness: 0.5.r,
      space: 1.r,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.primaryColor),
    ),
    extensions: [
      AppColorsExtension(
        primary: AppColors.primary100,
        secondary: AppColors.secondaryColor,
        grey: AppColors.grey300,
        lightGrey: AppColors.grey500,
        success: AppColors.success,
        error: AppColors.error,
        secondaryBlack: AppColors.grey200,
        bubbleGray: AppColors.grey400,
        iconColor: AppColors.grey200,
        bgGradient1: AppColors.bgGradient1,
        bgGradient2: AppColors.bgGradient2,
        ratingStarColor: AppColors.ratingStarColor,
      ),
    ],
    textTheme: _buildTextTheme(AppColors.grey200),
  );

  static final ThemeData darkTheme = ThemeData(
    fontFamily: GoogleFonts.lexend().fontFamily,
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBg,
    canvasColor: AppColors.darkBg,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBg,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.whiteColor),
      titleTextStyle: GoogleFonts.lexend(
        color: AppColors.whiteColor,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      ),
    ),
    iconTheme: const IconThemeData(color: AppColors.whiteColor),
    cardColor: AppColors.darkSurface,
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.darkSurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.largeRadius),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.darkBg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      modalElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.extraLargeRadius),
        ),
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryColor,
      onPrimary: AppColors.whiteColor,
      secondary: AppColors.grey200,
      surface: AppColors.darkBg,
      inversePrimary: AppColors.grey300,
      onSurface: AppColors.whiteColor,
      error: AppColors.error,
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.darkBg,
      thickness: 0.5.r,
      space: 1.r,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.primaryColor),
    ),
    extensions: [
      AppColorsExtension(
        primary: AppColors.primary100,
        secondary: AppColors.secondaryColor,
        grey: AppColors.grey300,
        lightGrey: AppColors.grey200,
        success: AppColors.success,
        error: AppColors.error,
        secondaryBlack: AppColors.whiteColor,
        bubbleGray: AppColors.grey300.withValues(alpha: 0.5),
        iconColor: AppColors.whiteColor,
        bgGradient1: AppColors.grey100,
        bgGradient2: AppColors.darkBg,
        ratingStarColor: AppColors.ratingStarColor,
      ),
    ],
    textTheme: _buildTextTheme(AppColors.whiteColor),
  );

  static TextTheme _buildTextTheme(Color textColor) {
    return TextTheme(
      displayLarge: GoogleFonts.lexend(
        fontSize: 34.sp,
        fontWeight: FontWeight.w600,
        height: 1.29,
        color: textColor,
      ),
      displayMedium: GoogleFonts.lexend(
        fontSize: 28.sp,
        fontWeight: FontWeight.w600,
        height: 1.28,
        color: textColor,
      ),
      displaySmall: GoogleFonts.lexend(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: textColor,
      ),
      headlineLarge: GoogleFonts.lexend(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.lexend(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        height: 1.22,
        color: textColor,
      ),
      headlineSmall: GoogleFonts.lexend(
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
        height: 1.33,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.lexend(
        fontSize: 17.sp,
        fontWeight: FontWeight.w400,
        height: 1.29,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.lexend(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        height: 1.26,
        color: textColor,
      ),
      bodySmall: GoogleFonts.lexend(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        height: 1.23,
        color: textColor,
      ),
      labelLarge: GoogleFonts.lexend(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        height: 1.25,
        color: textColor,
      ),
      labelMedium: GoogleFonts.lexend(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        height: 1.33,
        color: textColor,
      ),
      labelSmall: GoogleFonts.lexend(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        height: 1.18,
        color: textColor,
      ),
    );
  }
}
