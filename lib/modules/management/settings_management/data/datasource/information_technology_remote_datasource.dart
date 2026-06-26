abstract class InformationTechnologyRemoteDataSource {
  Future<Map<String, dynamic>> getInformationTechnologyStats();
}

class InformationTechnologyRemoteDataSourceImpl
    implements InformationTechnologyRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getInformationTechnologyStats() async {
    return {
      'active_support_tickets': 7,
      'network_uptime_pct': 99.98,
      'servers_status': 'All Healthy',
      'backups_last_run': '02:00 AM',
    };
  }
}
