import 'package:flutter/material.dart';

class AppDepartmentStyle {
  final List<Color> gradient;
  final Color lightCardBg;
  final Color darkCardBg;

  const AppDepartmentStyle({
    required this.gradient,
    required this.lightCardBg,
    required this.darkCardBg,
  });
}

class AppDepartmentColorHandler {
  AppDepartmentColorHandler._();

  static AppDepartmentStyle getStyle(String departmentName) {
    final hash = departmentName.trim().toLowerCase().hashCode.abs();

    // Generates a stable hue (0 - 359)
    final hue = (hash % 360).toDouble();

    final primary = HSLColor.fromAHSL(1, hue, 0.68, 0.52).toColor();

    final secondary = HSLColor.fromAHSL(1, hue, 0.68, 0.40).toColor();

    final lightCard = HSLColor.fromAHSL(1, hue, 0.40, 0.96).toColor();

    final darkCard = HSLColor.fromAHSL(1, hue, 0.35, 0.18).toColor();

    return AppDepartmentStyle(
      gradient: [primary, secondary],
      lightCardBg: lightCard,
      darkCardBg: darkCard,
    );
  }
}
