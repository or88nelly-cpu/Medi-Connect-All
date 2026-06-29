abstract class LaboratoryRemoteDataSource {
  Future<Map<String, dynamic>> getLaboratoryStats();
}

class LaboratoryRemoteDataSourceImpl implements LaboratoryRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getLaboratoryStats() async {
    return {
      'samples_collected_today': 185,
      'tests_completed_today': 142,
      'pending_reports': 43,
      'critical_alerts_sent': 2,
    };
  }
}
