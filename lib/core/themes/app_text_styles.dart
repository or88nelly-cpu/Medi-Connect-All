library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  AppTextStyles._();

  // =====================================================
  // FONT SIZES
  // =====================================================

  static double get s40 => 40.sp;
  static double get s36 => 36.sp;
  static double get s32 => 32.sp;
  static double get s28 => 28.sp;
  static double get s24 => 24.sp;
  static double get s20 => 20.sp;
  static double get s18 => 18.sp;
  static double get s16 => 16.sp;
  static double get s14 => 14.sp;
  static double get s12 => 12.sp;
  static double get s10 => 10.sp;

  // =====================================================
  // HEADINGS
  // =====================================================

  static TextStyle get headingXLarge => TextStyle(
    fontFamily: 'Inter',
    fontSize: s40,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get headingLarge => TextStyle(
    fontFamily: 'Inter',
    fontSize: s32,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get headingMedium => TextStyle(
    fontFamily: 'Inter',
    fontSize: s24,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get headingSmall => TextStyle(
    fontFamily: 'Inter',
    fontSize: s20,
    fontWeight: FontWeight.w700,
  );

  // =====================================================
  // TITLES
  // =====================================================

  static TextStyle get titleLarge => TextStyle(
    fontFamily: 'Inter',
    fontSize: s20,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get titleMedium => TextStyle(
    fontFamily: 'Inter',
    fontSize: s18,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get titleSmall => TextStyle(
    fontFamily: 'Inter',
    fontSize: s16,
    fontWeight: FontWeight.w600,
  );

  // =====================================================
  // BODY
  // =====================================================

  static TextStyle get bodyLarge => TextStyle(
    fontFamily: 'Inter',
    fontSize: s16,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontFamily: 'Inter',
    fontSize: s14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get bodySmall => TextStyle(
    fontFamily: 'Inter',
    fontSize: s12,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get bodyXSmall => TextStyle(
    fontFamily: 'Inter',
    fontSize: s10,
    fontWeight: FontWeight.w400,
  );

  // =====================================================
  // LABELS
  // =====================================================

  static TextStyle get labelLarge => TextStyle(
    fontFamily: 'Inter',
    fontSize: s16,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get labelMedium => TextStyle(
    fontFamily: 'Inter',
    fontSize: s14,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get labelSmall => TextStyle(
    fontFamily: 'Inter',
    fontSize: s12,
    fontWeight: FontWeight.w600,
  );

  // =====================================================
  // BUTTONS
  // =====================================================

  static TextStyle get buttonLarge => TextStyle(
    fontFamily: 'Inter',
    fontSize: s16,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get buttonMedium => TextStyle(
    fontFamily: 'Inter',
    fontSize: s14,
    fontWeight: FontWeight.w600,
  );

  // =====================================================
  // DASHBOARD
  // =====================================================

  static TextStyle get dashboardTitle => TextStyle(
    fontFamily: 'Inter',
    fontSize: s24,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get dashboardCardTitle => TextStyle(
    fontFamily: 'Inter',
    fontSize: s16,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get dashboardCardValue => TextStyle(
    fontFamily: 'Inter',
    fontSize: s28,
    fontWeight: FontWeight.w700,
  );

  // =====================================================
  // TERMINAL
  // =====================================================

  static TextStyle get terminalHeadingLarge => TextStyle(
    fontFamily: 'monospace',
    fontSize: s32,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get terminalHeadingMedium => TextStyle(
    fontFamily: 'monospace',
    fontSize: s24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle terminalMonospace = TextStyle(fontFamily: 'monospace');

  static TextStyle get terminalMonospaceLabel => TextStyle(
    fontFamily: 'monospace',
    fontSize: s12,
    fontWeight: FontWeight.bold,
    letterSpacing: .5,
  );

  static TextStyle get terminalBodyLarge =>
      TextStyle(fontFamily: 'monospace', fontSize: s16);

  static TextStyle get terminalBodyMedium =>
      TextStyle(fontFamily: 'monospace', fontSize: s14);

  static TextStyle get terminalBodySmall =>
      TextStyle(fontFamily: 'monospace', fontSize: s12);
}
