import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/doctor/dashboard/domain/entities/doctor_dashboard_stats.dart';
import 'package:medi_connect/features/doctor/dashboard/domain/entities/mrd_record_entity.dart';

abstract class DoctorDashboardRepository {
  Future<Either<Failure, DoctorDashboardStats>> getDashboardStats({
    required String doctorId,
    required DateTime date,
  });

  Future<Either<Failure, List<MrdRecordEntity>>> getPendingMrdRecords({
    required String doctorId,
  });
}
