abstract class NursingRemoteDataSource {
  Future<Map<String, dynamic>> getNursingStats();
}

class NursingRemoteDataSourceImpl implements NursingRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getNursingStats() async {
    return {
      'nurses_on_duty': 85,
      'ward_occupancy_pct': 82.4,
      'incident_reports_today': 0,
      'training_hours_completed': 12,
    };
  }
}
