import 'package:injectable/injectable.dart';

abstract class ManagementInformationSystemRemoteDataSource {
  Future<Map<String, dynamic>> getManagementInformationSystemStats();
}

@LazySingleton(as: ManagementInformationSystemRemoteDataSource)
class ManagementInformationSystemRemoteDataSourceImpl
    implements ManagementInformationSystemRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getManagementInformationSystemStats() async {
    return {
      'reports_generated_today': 12,
      'active_dashboards': 8,
      'data_sync_status': 'Synced',
      'system_performance_status': 'Optimal',
    };
  }
}
