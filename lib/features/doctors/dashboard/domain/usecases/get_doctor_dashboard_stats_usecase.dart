import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/doctors/dashboard/domain/entities/doctor_dashboard_stats.dart';
import 'package:medi_connect/features/doctors/dashboard/domain/repositories/doctor_dashboard_repository.dart';

class DoctorDashboardParams extends Equatable {
  final String doctorId;
  final DateTime date;

  const DoctorDashboardParams({required this.doctorId, required this.date});

  @override
  List<Object?> get props => [doctorId, date];
}

class GetDoctorDashboardStatsUseCase
    extends UseCase<DoctorDashboardStats, DoctorDashboardParams> {
  final DoctorDashboardRepository _repository;

  const GetDoctorDashboardStatsUseCase(this._repository);

  @override
  Future<Either<Failure, DoctorDashboardStats>> call(
    DoctorDashboardParams params,
  ) {
    return _repository.getDashboardStats(
      doctorId: params.doctorId,
      date: params.date,
    );
  }
}
