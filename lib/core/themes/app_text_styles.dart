/// Centralized typography definitions using flutter_screenutil for responsiveness.
/// Text styling must come from here to maintain visual consistency.
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  /// ScreenUtil-scaled font sizes.
  static double get s32 => 32.sp;
  static double get s24 => 24.sp;
  static double get s20 => 20.sp;
  static double get s18 => 18.sp;
  static double get s16 => 16.sp;
  static double get s14 => 14.sp;
  static double get s12 => 12.sp;

  /// Large heading style (e.g. Onboarding titles, big highlights).
  static TextStyle get headingLarge => TextStyle(
    fontFamily: 'Inter',
    fontSize: s32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  /// Medium heading style (e.g. Page titles, large sections).
  static TextStyle get headingMedium => TextStyle(
    fontFamily: 'Inter',
    fontSize: s24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  /// Large title style (e.g. Cards title, dialog header).
  static TextStyle get titleLarge => TextStyle(
    fontFamily: 'Inter',
    fontSize: s20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Medium title style (e.g. ListItem title, field label).
  static TextStyle get titleMedium => TextStyle(
    fontFamily: 'Inter',
    fontSize: s18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Large body text (e.g. standard body copy, input text).
  static TextStyle get bodyLarge => TextStyle(
    fontFamily: 'Inter',
    fontSize: s16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  /// Medium body text (e.g. secondary page descriptions).
  static TextStyle get bodyMedium => TextStyle(
    fontFamily: 'Inter',
    fontSize: s14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  /// Small body text (e.g. metadata, captions).
  static TextStyle get bodySmall => TextStyle(
    fontFamily: 'Inter',
    fontSize: s12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  /// Medium label text (e.g. button labels, action text).
  static TextStyle get labelMedium => TextStyle(
    fontFamily: 'Inter',
    fontSize: s14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Terminal theme styles
  static TextStyle get terminalHeadingLarge => TextStyle(
    fontFamily: 'Inter',
    fontSize: s32,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get terminalHeadingMedium => TextStyle(
    fontFamily: 'Inter',
    fontSize: s24,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get terminalMonospace =>
      const TextStyle(fontFamily: 'monospace');

  static TextStyle get terminalMonospaceLabel => TextStyle(
    fontFamily: 'monospace',
    fontSize: s12,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );

  static TextStyle get terminalBodyLarge =>
      TextStyle(fontFamily: 'monospace', fontSize: s16);

  static TextStyle get terminalBodyMedium =>
      TextStyle(fontFamily: 'monospace', fontSize: s14);

  static TextStyle get terminalBodySmall =>
      TextStyle(fontFamily: 'monospace', fontSize: s12);

  AppTextStyles._();
}
