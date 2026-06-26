abstract class PurchaseRemoteDataSource {
  Future<Map<String, dynamic>> getPurchaseStats();
}

class PurchaseRemoteDataSourceImpl implements PurchaseRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getPurchaseStats() async {
    return {
      'purchase_orders_pending': 15,
      'vendor_contracts_active': 24,
      'total_spending_this_month': 450000.0,
      'pending_deliveries': 8,
    };
  }
}
