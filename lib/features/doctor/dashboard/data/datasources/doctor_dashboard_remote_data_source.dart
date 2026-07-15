import 'package:medi_connect/features/doctor/dashboard/data/models/doctor_dashboard_stats_model.dart';
import 'package:medi_connect/features/doctor/dashboard/data/models/mrd_record_model.dart';

abstract class DoctorDashboardRemoteDataSource {
  Future<DoctorDashboardStatsModel> getDashboardStats({
    required String doctorId,
    required DateTime date,
  });

  Future<List<MrdRecordModel>> getPendingMrdRecords({required String doctorId});
}
