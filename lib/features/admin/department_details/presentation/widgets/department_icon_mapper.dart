import 'package:flutter/material.dart';

/// Maps a department name to a representative [IconData].
class DepartmentIconMapper {
  DepartmentIconMapper._();

  static IconData fromName(String name) {
    final n = name.toLowerCase();
    if (n.contains('cardio') || n.contains('heart'))
      return Icons.favorite_rounded;
    if (n.contains('neuro') || n.contains('brain'))
      return Icons.psychology_rounded;
    if (n.contains('ortho') || n.contains('bone'))
      return Icons.accessibility_new_rounded;
    if (n.contains('eye') || n.contains('ophthal'))
      return Icons.visibility_rounded;
    if (n.contains('dental') || n.contains('tooth'))
      return Icons.medical_services_rounded;
    if (n.contains('lab') || n.contains('pathol')) return Icons.science_rounded;
    if (n.contains('radiol') || n.contains('imaging') || n.contains('x-ray'))
      return Icons.crop_free_rounded;
    if (n.contains('pharma') || n.contains('drug'))
      return Icons.medication_rounded;
    if (n.contains('emerg') || n.contains('casualty') || n.contains('icu'))
      return Icons.local_hospital_rounded;
    if (n.contains('surgery') ||
        n.contains('operation') ||
        n.contains('theatre'))
      return Icons.cut_rounded;
    if (n.contains('paed') || n.contains('child') || n.contains('neonat'))
      return Icons.child_care_rounded;
    if (n.contains('gynae') || n.contains('obstet') || n.contains('maternity'))
      return Icons.pregnant_woman_rounded;
    if (n.contains('derma') || n.contains('skin')) return Icons.face_rounded;
    if (n.contains('psychiatr') || n.contains('mental'))
      return Icons.self_improvement_rounded;
    if (n.contains('physio') || n.contains('rehab'))
      return Icons.directions_walk_rounded;
    if (n.contains('nutrition') || n.contains('diet'))
      return Icons.restaurant_rounded;
    if (n.contains('nursing')) return Icons.person_rounded;
    if (n.contains('finance') || n.contains('billing') || n.contains('account'))
      return Icons.account_balance_wallet_rounded;
    if (n.contains('hr') || n.contains('human resource'))
      return Icons.groups_rounded;
    if (n.contains('it') || n.contains('information tech'))
      return Icons.computer_rounded;
    if (n.contains('store') || n.contains('supply')) return Icons.store_rounded;
    if (n.contains('security') || n.contains('fire'))
      return Icons.local_fire_department_rounded;
    if (n.contains('marketing')) return Icons.campaign_rounded;
    if (n.contains('purchase')) return Icons.shopping_cart_rounded;
    if (n.contains('ward')) return Icons.bed_rounded;
    if (n.contains('mep') || n.contains('engineer')) return Icons.build_rounded;
    if (n.contains('cssd') || n.contains('steril'))
      return Icons.clean_hands_rounded;
    if (n.contains('customer') || n.contains('care'))
      return Icons.headset_mic_rounded;
    if (n.contains('biomedical')) return Icons.biotech_rounded;
    if (n.contains('dyalis') || n.contains('kidney') || n.contains('renal'))
      return Icons.water_drop_rounded;
    if (n.contains('ambulance') || n.contains('transport'))
      return Icons.airport_shuttle_rounded;
    if (n.contains('manage') || n.contains('mis') || n.contains('admin'))
      return Icons.manage_accounts_rounded;
    if (n.contains('emrd')) return Icons.report_problem_rounded;
    return Icons.corporate_fare_rounded;
  }
}
