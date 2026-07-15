import 'package:injectable/injectable.dart';

abstract class CasualityRemoteDataSource {
  Future<Map<String, dynamic>> getCasualityStats();
}

@LazySingleton(as: CasualityRemoteDataSource)
class CasualityRemoteDataSourceImpl implements CasualityRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getCasualityStats() async {
    return {
      'triage_red': 2,
      'triage_yellow': 5,
      'triage_green': 12,
      'waiting_time_mins': 15,
      'beds_available': 4,
    };
  }
}
