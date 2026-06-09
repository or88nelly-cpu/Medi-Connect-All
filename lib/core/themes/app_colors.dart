/// Standard palette definition for the Healthcare Platform.
/// All colors utilized across applications must reside here.
import 'package:flutter/material.dart';

class AppColors {
  // Brand colors
  static const primary = Color(0xFF0F6FFF);
  static const secondary = Color(0xFF00C2A8);
  static const accent = Color(0xFFFFB547);

  // Status colors
  static const success = Color(0xFF34C759);
  static const warning = Color(0xFFFF9500);
  static const error = Color(0xFFFF3B30);

  // Background colors
  static const background = Color(0xFFF7FAFC);
  static const surface = Colors.white;

  // Text colors
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF6B7280);
  static const textLight = Colors.white;

  // Border & divider colors
  static const border = Color(0xFFE5E7EB);
  static const divider = Color(0xFFF3F4F6);

  // Admin and branding colors
  static const adminPrimary = Color(0xFF7928CA);
  static const adminSecondary = Color(0xFFFF0080);
  static const textDarkNavy = Color(0xFF0F2C59);

  // Role gradient palettes
  static const patientGradient = [Color(0xFF0F6FFF), Color(0xFF5A9CFF)];
  static const doctorGradient = [Color(0xFF00C2A8), Color(0xFF5CE1E6)];
  static const staffGradient = [Color(0xFFFFB547), Color(0xFFFFD08A)];
  static const adminGradient = [Color(0xFF7928CA), Color(0xFFFF0080)];

  // Floating medical cross opacity variants for splash
  static const primaryOpacity20 = Color(0x330F6FFF);
  static const primaryOpacity13 = Color(0x220F6FFF);
  static const primaryOpacity12 = Color(0x1F0F6FFF);
  static const primaryOpacity16 = Color(0x2A0F6FFF);

  // Dashboard Stat Card Colors
  static const infoIndigo = Color(0xFF3F51B5);
  static const infoTeal = Color(0xFF009688);
  static const infoOrange = Color(0xFFFF9800);
  static const infoPurple = Color(0xFF9C27B0);

  // Private constructor to prevent instantiation.
  AppColors._();
}
