abstract class WardRemoteDataSource {
  Future<Map<String, dynamic>> getWardStats();
}

class WardRemoteDataSourceImpl implements WardRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getWardStats() async {
    return {
      'beds_total': 150,
      'beds_occupied': 112,
      'admissions_today': 14,
      'discharges_today': 9,
      'nurse_call_response_time_mins': 4.5,
    };
  }
}
