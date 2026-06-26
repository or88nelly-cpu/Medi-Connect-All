library;

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // =====================================================
  // BRAND COLORS
  // =====================================================

  static const Color primary = Color(0xFF4F2DFF);
  static const Color primaryLight = Color(0xFF6A4DFF);
  static const Color primaryDark = Color(0xFF2D1AFF);
  static const textLight = Colors.white;

  static const Color secondary = Color(0xFF7B61FF);
  static const Color accent = Color(0xFFFFB547);
  static const divider = Color(0xFFF3F4F6);
  static const surface = Colors.white;

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

  // =====================================================
  // LIGHT THEME
  // =====================================================

  static const Color lightScaffold = Color(0xFFF5F7FC);
  static const Color lightBackground = Color(0xFFFFFFFF);

  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardSecondary = Color(0xFFF8FAFD);

  static const Color lightBorder = Color(0xFFE3E8F3);

  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF6B7280);

  static const Color lightShadow = Color(0x14000000);

  static const Color lightSidebar = Color(0xFFF0F5FF);

  static const Color lightHeaderStart = Color(0xFF2D2CFF);
  static const Color lightHeaderEnd = Color(0xFF742FFF);

  // =====================================================
  // DARK THEME
  // =====================================================

  static const Color darkScaffold = Color(0xFF050816);
  static const Color darkBackground = Color(0xFF0A1022);

  static const Color darkCard = Color(0xFF10192C);
  static const Color darkCardSecondary = Color(0xFF131D33);

  static const Color darkBorder = Color(0xFF26324D);

  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  static const Color darkShadow = Color(0x66000000);

  static const Color darkSidebar = Color(0xFF071122);

  static const Color darkHeaderStart = Color(0xFF0D0C5F);
  static const Color darkHeaderEnd = Color(0xFF34178D);

  // =====================================================
  // SHIMMER
  // =====================================================

  static const Color lightShimmerBase = Color(0xFFE8EDF5);
  static const Color lightShimmerHighlight = Color(0xFFF8FAFC);

  static const Color darkShimmerBase = Color(0xFF182338);
  static const Color darkShimmerHighlight = Color(0xFF24324C);

  // =====================================================
  // STATUS COLORS
  // =====================================================

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // =====================================================
  // DEPARTMENT ICON COLORS
  // =====================================================

  static const Color blue = Color(0xFF2F80FF);
  static const Color green = Color(0xFF22C55E);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color pink = Color(0xFFEC4899);
  static const Color orange = Color(0xFFFF8A26);
  static const Color teal = Color(0xFF14B8A6);
  static const Color red = Color(0xFFEF4444);

  // =====================================================
  // DEPARTMENT LIGHT BG
  // =====================================================

  static const Color lightBlueCard = Color(0xFFF3F8FF);
  static const Color lightGreenCard = Color(0xFFF2FFF7);
  static const Color lightPurpleCard = Color(0xFFF8F4FF);
  static const Color lightPinkCard = Color(0xFFFFF2F8);
  static const Color lightOrangeCard = Color(0xFFFFF7F0);
  static const Color lightTealCard = Color(0xFFF0FFFD);
  static const Color lightRedCard = Color(0xFFFFF3F3);

  // =====================================================
  // DEPARTMENT DARK BG
  // =====================================================

  static const Color darkBlueCard = Color(0xFF0D1B38);
  static const Color darkGreenCard = Color(0xFF0D261A);
  static const Color darkPurpleCard = Color(0xFF21133F);
  static const Color darkPinkCard = Color(0xFF34132A);
  static const Color darkOrangeCard = Color(0xFF38200F);
  static const Color darkTealCard = Color(0xFF0B2A28);
  static const Color darkRedCard = Color(0xFF341515);

  // =====================================================
  // GRADIENTS
  // =====================================================

  static const List<Color> lightHeaderGradient = [
    lightHeaderStart,
    lightHeaderEnd,
  ];

  static const List<Color> darkHeaderGradient = [
    darkHeaderStart,
    darkHeaderEnd,
  ];

  static const List<Color> blueGradient = [
    Color(0xFF4DA3FF),
    Color(0xFF0066FF),
  ];

  static const List<Color> greenGradient = [
    Color(0xFF4ADE80),
    Color(0xFF16A34A),
  ];

  static const List<Color> purpleGradient = [
    Color(0xFFA78BFA),
    Color(0xFF7C3AED),
  ];

  static const List<Color> pinkGradient = [
    Color(0xFFFF66C4),
    Color(0xFFEC4899),
  ];

  static const List<Color> orangeGradient = [
    Color(0xFFFFB366),
    Color(0xFFFF8A26),
  ];

  static const List<Color> redGradient = [Color(0xFFFF5B5B), Color(0xFFEF4444)];

  // =====================================================
  // THEME HELPERS
  // =====================================================

  static const List<Color> registrationGradient = [
    Color(0xFF0F6FFF),
    Color(0xFF0056C6),
  ];
  static const List<Color> qrRegistrationGradient = [
    Color(0xFF00C2A8),
    Color(0xFF009688),
  ];
  static const List<Color> appointmentGradient = [
    Color(0xFF7B61FF),
    Color(0xFF4F2DFF),
  ];
  static const List<Color> patientSearchGradient = [
    Color(0xFF0F6FFF),
    Color(0xFF4F2DFF),
  ];
  static const List<Color> admissionGradient = [
    Color(0xFFFF8A26),
    Color(0xFFFFB547),
  ];
  static const List<Color> feedbackGradient = [
    Color(0xFFEC4899),
    Color(0xFFFF0080),
  ];

  static Color dashboardCardBg(BuildContext context) =>
      isDark(context) ? const Color(0xFF09121F) : Colors.white;

  static Color dashboardCardBorder(BuildContext context) =>
      isDark(context) ? const Color(0xFF16253B) : const Color(0xFFD3E0EE);

  static Color dashboardTextPrimary(BuildContext context) =>
      isDark(context) ? Colors.white : const Color(0xFF0F2C59);

  static Color dashboardTextSecondary(BuildContext context) =>
      isDark(context) ? const Color(0xFF5E98C7) : const Color(0xFF3F6D94);

  static Color dashboardHighlight(BuildContext context) =>
      isDark(context) ? const Color(0xFF0A1E3F) : const Color(0xFFE2EAF4);

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color scaffold(BuildContext context) =>
      isDark(context) ? darkScaffold : lightScaffold;

  static Color background(BuildContext context) =>
      isDark(context) ? darkBackground : lightBackground;

  static Color card(BuildContext context) =>
      isDark(context) ? darkCard : lightCard;

  static Color cardSecondary(BuildContext context) =>
      isDark(context) ? darkCardSecondary : lightCardSecondary;

  static Color border(BuildContext context) =>
      isDark(context) ? darkBorder : lightBorder;

  static Color textPrimary(BuildContext context) =>
      isDark(context) ? darkTextPrimary : lightTextPrimary;

  static Color textSecondary(BuildContext context) =>
      isDark(context) ? darkTextSecondary : lightTextSecondary;

  static Color shadow(BuildContext context) =>
      isDark(context) ? darkShadow : lightShadow;

  static Color sidebar(BuildContext context) =>
      isDark(context) ? darkSidebar : lightSidebar;

  static List<Color> headerGradient(BuildContext context) =>
      isDark(context) ? darkHeaderGradient : lightHeaderGradient;

  static Color shimmerBase(BuildContext context) =>
      isDark(context) ? darkShimmerBase : lightShimmerBase;

  static Color shimmerHighlight(BuildContext context) =>
      isDark(context) ? darkShimmerHighlight : lightShimmerHighlight;
}
