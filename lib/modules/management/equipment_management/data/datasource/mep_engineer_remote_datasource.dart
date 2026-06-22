abstract class MepEngineerRemoteDataSource {
  Future<Map<String, dynamic>> getMepEngineerStats();
}

class MepEngineerRemoteDataSourceImpl implements MepEngineerRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getMepEngineerStats() async {
    return {
      'chillers_status': 'Normal',
      'generators_status': 'Standby',
      'water_levels_status': '92%',
      'active_maintenance_jobs': 4,
    };
  }
}
