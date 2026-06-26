import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/staff_management/domain/repositories/nursing_repository.dart';

class GetNursingStatsUseCase extends UseCase<Map<String, dynamic>, NoParams> {
  final NursingRepository _repository;
  GetNursingStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getNursingStats();
  }
}
