abstract class PhysioTherapyRemoteDataSource {
  Future<Map<String, dynamic>> getPhysioTherapyStats();
}

class PhysioTherapyRemoteDataSourceImpl implements PhysioTherapyRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getPhysioTherapyStats() async {
    return {
      'active_sessions': 8,
      'patients_treated_today': 36,
      'equipment_available_pct': 100.0,
      'rehab_plans_active': 52,
    };
  }
}
