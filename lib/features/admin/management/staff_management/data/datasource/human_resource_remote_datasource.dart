import 'package:injectable/injectable.dart';

abstract class HumanResourceRemoteDataSource {
  Future<Map<String, dynamic>> getHumanResourceStats();
}

@LazySingleton(as: HumanResourceRemoteDataSource)
class HumanResourceRemoteDataSourceImpl
    implements HumanResourceRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getHumanResourceStats() async {
    return {
      'total_employees': 450,
      'active_onboarding': 8,
      'leave_requests_pending': 12,
      'open_requisitions': 15,
    };
  }
}
