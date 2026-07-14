import 'package:flutter/material.dart';

/// Maps entity names to semantic [IconData] icons.
/// Used by department and speciality grid cards to avoid duplicating icon logic inside widgets.
class EntityIconMapper {
  EntityIconMapper._();

  /// Returns a department icon based on [name].
  static IconData forDepartment(String name) {
    final n = name.toLowerCase();
    if (n.contains('emergency')) return Icons.emergency_outlined;
    if (n.contains('lab') || n.contains('laboratory'))
      return Icons.biotech_outlined;
    if (n.contains('pharmacy')) return Icons.medication_outlined;
    if (n.contains('radiology') || n.contains('imaging'))
      return Icons.blur_circular_outlined;
    if (n.contains('icu') || n.contains('intensive'))
      return Icons.monitor_heart_outlined;
    if (n.contains('surgery') ||
        n.contains('surgical') ||
        n.contains('theatre'))
      return Icons.healing_outlined;
    if (n.contains('paediatric') ||
        n.contains('pediatric') ||
        n.contains('child'))
      return Icons.child_care_outlined;
    if (n.contains('cardio') || n.contains('heart'))
      return Icons.favorite_outline;
    if (n.contains('neuro') || n.contains('brain'))
      return Icons.psychology_outlined;
    if (n.contains('ortho') || n.contains('bone'))
      return Icons.accessible_forward_outlined;
    if (n.contains('dental') || n.contains('dentist'))
      return Icons.face_outlined;
    if (n.contains('eye') || n.contains('ophthal'))
      return Icons.remove_red_eye_outlined;
    if (n.contains('nursing')) return Icons.people_outline;
    if (n.contains('admin') || n.contains('management'))
      return Icons.admin_panel_settings_outlined;
    if (n.contains('bio') || n.contains('engineering'))
      return Icons.precision_manufacturing_outlined;
    if (n.contains('casualty')) return Icons.local_hospital_outlined;
    if (n.contains('outpatient') || n.contains('opd'))
      return Icons.person_outline;
    if (n.contains('physiother') || n.contains('rehab'))
      return Icons.directions_walk_outlined;
    if (n.contains('diet') || n.contains('nutrition'))
      return Icons.restaurant_outlined;
    return Icons.local_hospital_outlined;
  }

  /// Returns a speciality icon based on [name].
  static IconData forSpeciality(String name) {
    final n = name.toLowerCase();
    if (n.contains('cardio') || n.contains('heart'))
      return Icons.favorite_outline;
    if (n.contains('neuro') || n.contains('brain'))
      return Icons.psychology_outlined;
    if (n.contains('ortho') || n.contains('bone'))
      return Icons.accessible_forward_outlined;
    if (n.contains('paediatric') ||
        n.contains('pediatric') ||
        n.contains('child'))
      return Icons.child_care_outlined;
    if (n.contains('ent') || n.contains('ear') || n.contains('hearing'))
      return Icons.hearing_outlined;
    if (n.contains('derma') || n.contains('skin')) return Icons.face_outlined;
    if (n.contains('dental') || n.contains('dentist'))
      return Icons.face_retouching_natural;
    if (n.contains('anaes') || n.contains('anesthes'))
      return Icons.air_outlined;
    if (n.contains('oncol') || n.contains('cancer'))
      return Icons.science_outlined;
    if (n.contains('ophthal') || n.contains('eye'))
      return Icons.remove_red_eye_outlined;
    if (n.contains('gastro') || n.contains('digest'))
      return Icons.restaurant_outlined;
    if (n.contains('pulmo') || n.contains('lung') || n.contains('respir'))
      return Icons.air_outlined;
    if (n.contains('urol')) return Icons.water_drop_outlined;
    if (n.contains('gynae') || n.contains('gynec') || n.contains('obstetr'))
      return Icons.pregnant_woman_outlined;
    if (n.contains('psychi') || n.contains('mental'))
      return Icons.self_improvement_outlined;
    if (n.contains('nephro') || n.contains('kidney'))
      return Icons.water_drop_outlined;
    if (n.contains('endocrin') || n.contains('diabetes'))
      return Icons.science_outlined;
    if (n.contains('rheumat')) return Icons.accessible_outlined;
    if (n.contains('general') || n.contains('medicine'))
      return Icons.medical_services_outlined;
    return Icons.medical_services_outlined;
  }
}
