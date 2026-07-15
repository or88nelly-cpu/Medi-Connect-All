import 'package:injectable/injectable.dart';

abstract class PharmacyRemoteDataSource {
  Future<Map<String, dynamic>> getPharmacyStats();
}

@LazySingleton(as: PharmacyRemoteDataSource)
class PharmacyRemoteDataSourceImpl implements PharmacyRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getPharmacyStats() async {
    return {
      'prescriptions_dispensed_today': 420,
      'out_of_stock_medicines': 8,
      'reorder_alerts_triggered': 3,
      'vault_temp_celsius': 4.2,
    };
  }
}
