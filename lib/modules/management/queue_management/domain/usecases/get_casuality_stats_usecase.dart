import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/queue_management/domain/repositories/casuality_repository.dart';

class GetCasualityStatsUseCase extends UseCase<Map<String, dynamic>, NoParams> {
  final CasualityRepository _repository;
  GetCasualityStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getCasualityStats();
  }
}
