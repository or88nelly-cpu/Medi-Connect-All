library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDimensions {
  AppDimensions._();

  // Paddings & Margins
  static double get paddingXS => 4.w;
  static double get paddingS => 8.w;
  static double get paddingM => 12.w;
  static double get paddingL => 16.w;
  static double get paddingXL => 20.w;
  static double get paddingXXL => 24.w;
  static double get padding32 => 32.w;

  static double get marginXS => 4.w;
  static double get marginS => 8.w;
  static double get marginM => 12.w;
  static double get marginL => 16.w;
  static double get marginXL => 20.w;
  static double get marginXXL => 24.w;

  // SizedBox heights
  static double get spaceXS => 4.h;
  static double get spaceS => 8.h;
  static double get spaceM => 12.h;
  static double get spaceL => 16.h;
  static double get spaceXL => 20.h;
  static double get spaceXXL => 24.h;
  static double get space32 => 32.h;

  // SizedBox widths
  static double get spaceWXS => 4.w;
  static double get spaceWS => 8.w;
  static double get spaceWM => 12.w;
  static double get spaceWL => 16.w;
  static double get spaceWXL => 20.w;
  static double get spaceWXXL => 24.w;

  // Border Radii
  static double get radiusXS => 4.r;
  static double get radiusS => 8.r;
  static double get radiusM => 12.r;
  static double get radiusL => 16.r;
  static double get radiusXL => 20.r;
  static double get radiusXXL => 24.r;
  static double get radiusCircular => 999.r;

  // Elevations
  static double get elevationLow => 2.0;
  static double get elevationMedium => 4.0;
  static double get elevationHigh => 8.0;
}
