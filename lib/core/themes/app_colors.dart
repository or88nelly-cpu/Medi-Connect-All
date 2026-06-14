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

  // Terminal theme colors
  static const terminalDarkBg = Color(0xFF03070E);
  static const terminalLightBg = Color(0xFFF4F7FA);
  static const terminalDarkBgGrad1 = Color(0xFF0A1E3F);
  static const terminalDarkBgGrad2 = Color(0xFF030914);
  static const terminalLightBgGrad1 = Color(0xFFE2EAF4);
  static const terminalLightBgGrad2 = Color(0xFFF3F7FD);
  static const terminalDarkCard = Color(0xFF09121F);
  static const terminalLightCard = Colors.white;
  static const terminalDarkBorder = Color(0xFF16253B);
  static const terminalLightBorder = Color(0xFFD3E0EE);
  static const terminalDarkText = Colors.white;
  static const terminalLightText = Color(0xFF0C192E);
  static const terminalDarkLabel = Color(0xFF5E98C7);
  static const terminalLightLabel = Color(0xFF3F6D94);
  static const terminalDarkFieldFill = Color(0xFF050C16);
  static const terminalLightFieldFill = Color(0xFFEDF2F7);
  static const terminalDarkFieldBorder = Color(0xFF16253B);
  static const terminalLightFieldBorder = Color(0xFFD0DCEB);
  static const terminalDarkFieldHint = Color(0xFF334354);
  static const terminalLightFieldHint = Color(0xFF94A3B8);
  static const terminalDarkCheckboxText = Color(0xFF8FA2B6);
  static const terminalLightCheckboxText = Color(0xFF4A5568);
  static const terminalDarkFooterText = Color(0xFF5A6E85);
  static const terminalLightFooterText = Color(0xFF718096);
  static const terminalAccentCyan = Color(0xFF37B0F1);

  // Status background & text variants
  static const statusConfirmedBgDark = Color(0xFF064E3B);
  static const statusConfirmedBgLight = Color(0xFFDCFCE7);
  static const statusConfirmedTextDark = Color(0xFF4ADE80);
  static const statusConfirmedTextLight = Color(0xFF15803D);

  static const statusPendingBgDark = Color(0xFF7C2D12);
  static const statusPendingBgLight = Color(0xFFFFEDD5);
  static const statusPendingTextDark = Color(0xFFFDBA74);
  static const statusPendingTextLight = Color(0xFFC2410C);

  static const statusCompletedBgDark = Color(0xFF3B0764);
  static const statusCompletedBgLight = Color(0xFFF3E8FF);
  static const statusCompletedTextDark = Color(0xFFC084FC);
  static const statusCompletedTextLight = Color(0xFF7E22CE);

  static const statusCancelledBgDark = Color(0xFF7F1D1D);
  static const statusCancelledBgLight = Color(0xFFFEE2E2);
  static const statusCancelledTextDark = Color(0xFFFCA5A5);
  static const statusCancelledTextLight = Color(0xFFB91C1C);

  // Chip colors
  static const patientChipBgDark = Color(0xFF0F2C59);
  static const patientChipBgLight = Color(0xFFE0F2FE);
  static const patientChipTextDark = Color(0xFF38BDF8);
  static const patientChipTextLight = Color(0xFF0369A1);

  // Private constructor to prevent instantiation.
  AppColors._();
}
