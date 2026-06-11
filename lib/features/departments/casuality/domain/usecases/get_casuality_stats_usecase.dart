import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/features/departments/casuality/domain/repositories/casuality_repository.dart';

class GetCasualityStatsUseCase extends UseCase<Map<String, dynamic>, NoParams> {
  final CasualityRepository _repository;
  GetCasualityStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getCasualityStats();
  }
}
