import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/doctor/dashboard/data/datasources/doctor_dashboard_remote_data_source.dart';
import 'package:medi_connect/features/doctor/dashboard/domain/entities/doctor_dashboard_stats.dart';
import 'package:medi_connect/features/doctor/dashboard/domain/entities/mrd_record_entity.dart';
import 'package:medi_connect/features/doctor/dashboard/domain/repositories/doctor_dashboard_repository.dart';

@LazySingleton(as: DoctorDashboardRepository)
class DoctorDashboardRepositoryImpl implements DoctorDashboardRepository {
  final DoctorDashboardRemoteDataSource _remoteDataSource;

  DoctorDashboardRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, DoctorDashboardStats>> getDashboardStats({
    required String doctorId,
    required DateTime date,
  }) async {
    try {
      final stats = await _remoteDataSource.getDashboardStats(
        doctorId: doctorId,
        date: date,
      );
      return Right(stats);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MrdRecordEntity>>> getPendingMrdRecords({
    required String doctorId,
  }) async {
    try {
      final records = await _remoteDataSource.getPendingMrdRecords(
        doctorId: doctorId,
      );
      return Right(records);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
