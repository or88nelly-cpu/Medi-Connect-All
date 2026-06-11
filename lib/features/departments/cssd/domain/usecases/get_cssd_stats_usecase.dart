import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/features/departments/cssd/domain/repositories/cssd_repository.dart';

class GetCssdStatsUseCase extends UseCase<Map<String, dynamic>, NoParams> {
  final CssdRepository _repository;
  GetCssdStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getCssdStats();
  }
}
