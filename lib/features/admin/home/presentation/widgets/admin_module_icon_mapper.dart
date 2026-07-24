import 'package:flutter/material.dart';

/// Maps iconKey strings from AdminDashboardModuleEntity to Material IconData.
class AdminModuleIconMapper {
  AdminModuleIconMapper._();

  static IconData fromKey(String key) {
    switch (key) {
      case 'hospital':
        return Icons.local_hospital_rounded;
      case 'departments':
        return Icons.corporate_fare_rounded;
      case 'specialisations':
        return Icons.verified_user_rounded;
      case 'doctors':
        return Icons.medical_services_rounded;
      case 'staff':
        return Icons.people_alt_rounded;
      case 'patients':
        return Icons.single_bed_rounded;
      case 'appointments':
        return Icons.event_available_rounded;
      case 'beds':
        return Icons.bed_rounded;
      case 'billing':
        return Icons.receipt_long_rounded;
      case 'pharmacy':
        return Icons.medication_rounded;
      case 'laboratory':
        return Icons.science_rounded;
      case 'equipment':
        return Icons.monitor_heart_rounded;
      case 'insurance':
        return Icons.health_and_safety_rounded;
      case 'ambulance':
        return Icons.airport_shuttle_rounded;
      case 'roles':
        return Icons.admin_panel_settings_rounded;
      case 'settings':
        return Icons.settings_suggest_rounded;
      default:
        return Icons.dashboard_customize_rounded;
    }
  }
}
