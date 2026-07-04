abstract class BiomedicalEngineeringRemoteDataSource {
  Future<Map<String, dynamic>> getBiomedicalEngineeringStats();
}

class BiomedicalEngineeringRemoteDataSourceImpl
    implements BiomedicalEngineeringRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getBiomedicalEngineeringStats() async {
    return {
      'equipment_total': 120,
      'equipment_under_maintenance': 5,
      'calibration_pending': 8,
      'service_requests_active': 3,
    };
  }
}
