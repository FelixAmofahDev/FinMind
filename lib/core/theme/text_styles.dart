import 'package:flutter/material.dart';

import 'colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static const TextStyle displayLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.15,
    letterSpacing: -0.6,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.4,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static TextTheme lightTextTheme() {
    return const TextTheme(
      displayLarge: displayLarge,
      headlineLarge: headlineLarge,
      titleLarge: titleLarge,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
    );
  }

  static TextTheme darkTextTheme() {
    return const TextTheme(
      displayLarge: displayLarge,
      headlineLarge: headlineLarge,
      titleLarge: titleLarge,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
    ).apply(
      bodyColor: AppColors.darkTextPrimary,
      displayColor: AppColors.darkTextPrimary,
    );
  }
}