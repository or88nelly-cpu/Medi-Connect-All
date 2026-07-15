import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/doctor/dashboard/domain/entities/mrd_record_entity.dart';
import 'package:medi_connect/features/doctor/dashboard/domain/repositories/doctor_dashboard_repository.dart';

@lazySingleton
class GetPendingMrdRecordsUseCase
    extends UseCase<List<MrdRecordEntity>, String> {
  final DoctorDashboardRepository _repository;

  const GetPendingMrdRecordsUseCase(this._repository);

  @override
  Future<Either<Failure, List<MrdRecordEntity>>> call(String doctorId) {
    return _repository.getPendingMrdRecords(doctorId: doctorId);
  }
}
