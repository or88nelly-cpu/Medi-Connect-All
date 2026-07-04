abstract class OperationTheatreRemoteDataSource {
  Future<Map<String, dynamic>> getOperationTheatreStats();
}

class OperationTheatreRemoteDataSourceImpl
    implements OperationTheatreRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getOperationTheatreStats() async {
    return {
      'active_surgeries': 4,
      'scheduled_surgeries_today': 18,
      'completed_surgeries_today': 11,
      'ot_occupancy_pct': 75.0,
    };
  }
}
