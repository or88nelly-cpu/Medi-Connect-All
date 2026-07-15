import 'package:injectable/injectable.dart';

abstract class RadiologyRemoteDataSource {
  Future<Map<String, dynamic>> getRadiologyStats();
}

@LazySingleton(as: RadiologyRemoteDataSource)
class RadiologyRemoteDataSourceImpl implements RadiologyRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getRadiologyStats() async {
    return {
      'xray_completed_today': 45,
      'mri_scans_completed_today': 12,
      'ct_scans_completed_today': 18,
      'pending_radiology_reports': 9,
    };
  }
}
