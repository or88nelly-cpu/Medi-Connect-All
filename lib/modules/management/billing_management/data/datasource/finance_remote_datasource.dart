abstract class FinanceRemoteDataSource {
  Future<Map<String, dynamic>> getFinanceStats();
}

class FinanceRemoteDataSourceImpl implements FinanceRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getFinanceStats() async {
    return {
      'billing_processed_today': 85,
      'total_collections_today': 125430.0,
      'pending_claims': 42,
      'insurance_approvals_pct': 91.2,
    };
  }
}
