abstract class GeneralStoreRemoteDataSource {
  Future<Map<String, dynamic>> getGeneralStoreStats();
}

class GeneralStoreRemoteDataSourceImpl implements GeneralStoreRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getGeneralStoreStats() async {
    return {
      'inventory_items_total': 1250,
      'low_stock_items': 14,
      'orders_placed_today': 3,
      'deliveries_received_today': 5,
    };
  }
}
