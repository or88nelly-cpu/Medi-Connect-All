import 'package:flutter/material.dart';
import 'package:medi_connect/core/navigation/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

/// Data model for a management card.
/// All accent colors reference [AppColors] constants — no inline hex values.
class ManagementCardData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final String route;

  const ManagementCardData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.route,
  });

  /// All management cards shown on the admin dashboard.
  static const List<ManagementCardData> all = [
    ManagementCardData(
      title: 'Staff',
      subtitle: 'Doctors & employees',
      icon: Icons.people_alt_outlined,
      accentColor: AppColors.info,
      route: '/admin/staff',
    ),
    ManagementCardData(
      title: 'Patients',
      subtitle: 'Admissions & records',
      icon: Icons.personal_injury_outlined,
      accentColor: AppColors.success,
      route: '/admin/patients',
    ),
    ManagementCardData(
      title: 'Departments',
      subtitle: 'Wards & rooms',
      icon: Icons.domain_outlined,
      accentColor: AppColors.blue,
      route: RouteNames.adminDepartments,
    ),
    ManagementCardData(
      title: 'Specialities',
      subtitle: 'Clinical specialties',
      icon: Icons.medical_services_outlined,
      accentColor: AppColors.purple,
      route: RouteNames.adminSpecialities,
    ),
    ManagementCardData(
      title: 'Finance',
      subtitle: 'Billing & payments',
      icon: Icons.account_balance_wallet_outlined,
      accentColor: AppColors.warning,
      route: '/admin/finance',
    ),
    ManagementCardData(
      title: 'Settings',
      subtitle: 'Roles & config',
      icon: Icons.settings_outlined,
      accentColor: AppColors.teal,
      route: RouteNames.adminSettings,
    ),
  ];
}
