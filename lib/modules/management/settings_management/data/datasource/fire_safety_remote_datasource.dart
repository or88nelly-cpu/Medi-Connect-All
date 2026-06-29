abstract class FireSafetyRemoteDataSource {
  Future<Map<String, dynamic>> getFireSafetyStats();
}

class FireSafetyRemoteDataSourceImpl implements FireSafetyRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getFireSafetyStats() async {
    return {
      'extinguishers_checked': 45,
      'smoke_detectors_status': 'All Functional',
      'last_drill_date': 'May 12, 2026',
      'active_alerts': 0,
    };
  }
}
