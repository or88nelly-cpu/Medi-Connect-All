import 'package:flutter/material.dart';

class AppResponsive {
  AppResponsive._();

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  static int departmentGridCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 1600) return 8;
    if (width >= 1400) return 7;
    if (width >= 1200) return 6;
    if (width >= 900) return 5;
    if (width >= 700) return 4;
    return 3;
  }

  static double horizontalPadding(BuildContext context) {
    if (isDesktop(context)) return 32;
    if (isTablet(context)) return 24;
    return 16;
  }

  static double cardRadius(BuildContext context) {
    if (isDesktop(context)) return 24;
    if (isTablet(context)) return 20;
    return 16;
  }

  static Size getDesignSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 1200) {
      return const Size(1440, 1024);
    }

    if (width >= 600) {
      return const Size(768, 1024);
    }

    return const Size(390, 844);
  }
}
