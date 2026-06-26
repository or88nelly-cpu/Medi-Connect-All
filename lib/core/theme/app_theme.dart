library;

import 'package:flutter/material.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class AppTheme {
  AppTheme._();

  // =========================================================
  // LIGHT THEME
  // =========================================================

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      primaryColor: AppColors.primary,

      scaffoldBackgroundColor: AppColors.lightScaffold,

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.lightCard,
        error: AppColors.error,
      ),

      cardColor: AppColors.lightCard,

      dividerColor: AppColors.lightBorder,

      shadowColor: AppColors.lightShadow,

      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.lightCard,
        foregroundColor: AppColors.lightTextPrimary,
        iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
      ),

      iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),

      textTheme: TextTheme(
        headlineLarge: AppTextStyles.headingLarge.copyWith(
          color: AppColors.lightTextPrimary,
        ),

        headlineMedium: AppTextStyles.headingMedium.copyWith(
          color: AppColors.lightTextPrimary,
        ),

        titleLarge: AppTextStyles.titleLarge.copyWith(
          color: AppColors.lightTextPrimary,
        ),

        titleMedium: AppTextStyles.titleMedium.copyWith(
          color: AppColors.lightTextPrimary,
        ),

        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.lightTextPrimary,
        ),

        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.lightTextSecondary,
        ),

        bodySmall: AppTextStyles.bodySmall.copyWith(
          color: AppColors.lightTextSecondary,
        ),

        labelMedium: AppTextStyles.labelMedium.copyWith(
          color: AppColors.lightTextPrimary,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
    );
  }

  // =========================================================
  // DARK THEME
  // =========================================================

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      primaryColor: AppColors.primary,

      scaffoldBackgroundColor: AppColors.darkScaffold,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.darkCard,
        error: AppColors.error,
      ),

      cardColor: AppColors.darkCard,

      dividerColor: AppColors.darkBorder,

      shadowColor: AppColors.darkShadow,

      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.darkCard,
        foregroundColor: AppColors.darkTextPrimary,
        iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
      ),

      iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),

      textTheme: TextTheme(
        headlineLarge: AppTextStyles.headingLarge.copyWith(
          color: AppColors.darkTextPrimary,
        ),

        headlineMedium: AppTextStyles.headingMedium.copyWith(
          color: AppColors.darkTextPrimary,
        ),

        titleLarge: AppTextStyles.titleLarge.copyWith(
          color: AppColors.darkTextPrimary,
        ),

        titleMedium: AppTextStyles.titleMedium.copyWith(
          color: AppColors.darkTextPrimary,
        ),

        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.darkTextPrimary,
        ),

        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.darkTextSecondary,
        ),

        bodySmall: AppTextStyles.bodySmall.copyWith(
          color: AppColors.darkTextSecondary,
        ),

        labelMedium: AppTextStyles.labelMedium.copyWith(
          color: AppColors.darkTextPrimary,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
    );
  }
}
