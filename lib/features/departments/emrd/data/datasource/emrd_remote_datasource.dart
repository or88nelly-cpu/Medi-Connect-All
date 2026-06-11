abstract class EmrdRemoteDataSource {
  Future<Map<String, dynamic>> getEmrdStats();
}

class EmrdRemoteDataSourceImpl implements EmrdRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getEmrdStats() async {
    return {
      'records_scanned_today': 320,
      'pending_digitization': 45,
      'retrieval_requests_active': 2,
      'storage_capacity_used_pct': 78.4,
    };
  }
}
