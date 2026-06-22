import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/consultation_management/domain/repositories/physio_therapy_repository.dart';

class GetPhysioTherapyStatsUseCase
    extends UseCase<Map<String, dynamic>, NoParams> {
  final PhysioTherapyRepository _repository;
  GetPhysioTherapyStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getPhysioTherapyStats();
  }
}
