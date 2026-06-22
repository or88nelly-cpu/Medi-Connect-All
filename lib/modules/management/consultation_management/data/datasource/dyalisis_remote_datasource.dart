abstract class DyalisisRemoteDataSource {
  Future<Map<String, dynamic>> getDyalisisStats();
}

class DyalisisRemoteDataSourceImpl implements DyalisisRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getDyalisisStats() async {
    return {
      'active_dialysis_machines': 12,
      'scheduled_patients_today': 24,
      'completed_sessions_today': 14,
      'water_quality_status': 'Optimal',
    };
  }
}
