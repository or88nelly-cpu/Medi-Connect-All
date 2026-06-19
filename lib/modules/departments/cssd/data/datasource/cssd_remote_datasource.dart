abstract class CssdRemoteDataSource {
  Future<Map<String, dynamic>> getCssdStats();
}

class CssdRemoteDataSourceImpl implements CssdRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getCssdStats() async {
    return {
      'autoclaves_running': 3,
      'sterilization_batches_today': 14,
      'pending_packs': 45,
      'clean_packs_delivered': 120,
    };
  }
}
