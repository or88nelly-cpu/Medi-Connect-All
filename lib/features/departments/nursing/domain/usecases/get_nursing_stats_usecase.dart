import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/features/departments/nursing/domain/repositories/nursing_repository.dart';

class GetNursingStatsUseCase extends UseCase<Map<String, dynamic>, NoParams> {
  final NursingRepository _repository;
  GetNursingStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getNursingStats();
  }
}
