import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/modules/departments/mep_engineer/domain/repositories/mep_engineer_repository.dart';

class GetMepEngineerStatsUseCase
    extends UseCase<Map<String, dynamic>, NoParams> {
  final MepEngineerRepository _repository;
  GetMepEngineerStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getMepEngineerStats();
  }
}
