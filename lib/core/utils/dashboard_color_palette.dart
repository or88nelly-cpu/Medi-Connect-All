import 'package:flutter/material.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

/// A deterministic palette used for department/speciality icon circle colors.
/// Colors are selected from [AppColors] to stay consistent with the design system.
/// The same name always gets the same color (via hash).
class DashboardColorPalette {
  DashboardColorPalette._();

  static const List<Color> palette = [
    AppColors.error, // Red
    AppColors.info, // Blue
    AppColors.success, // Green
    AppColors.purple, // Purple
    AppColors.teal, // Teal
    AppColors.orange, // Orange
    AppColors.warning, // Amber/Yellow
    AppColors.pink, // Pink
    AppColors.adminPrimary, // Indigo/Violet
    AppColors.blue, // Bright blue
  ];

  /// Returns a deterministic [Color] from the palette for a given [name].
  static Color forName(String name) {
    int hash = 0;
    for (int i = 0; i < name.length; i++) {
      hash = name.codeUnitAt(i) + ((hash << 5) - hash);
    }
    return palette[hash.abs() % palette.length];
  }

  /// Returns the icon circle background color (10% opacity) for a given [name].
  static Color bgForName(String name, {bool isDark = false}) {
    return forName(name).withValues(alpha: isDark ? 0.15 : 0.10);
  }

  /// Returns the card border color (15% opacity) for a given [name].
  static Color borderForName(String name) {
    return forName(name).withValues(alpha: 0.15);
  }

  /// Returns the shadow color (6% opacity) for a given [name].
  static Color shadowForName(String name) {
    return forName(name).withValues(alpha: 0.06);
  }
}
