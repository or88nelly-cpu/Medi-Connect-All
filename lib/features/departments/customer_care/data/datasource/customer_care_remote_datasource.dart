abstract class CustomerCareRemoteDataSource {
  Future<Map<String, dynamic>> getCustomerCareStats();
}

class CustomerCareRemoteDataSourceImpl implements CustomerCareRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getCustomerCareStats() async {
    return {
      'active_tickets': 18,
      'avg_response_time_mins': 8,
      'patient_satisfaction_pct': 94.5,
      'calls_received_today': 150,
    };
  }
}
