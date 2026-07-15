import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/admin/management/queue_management/domain/repositories/casuality_repository.dart';

@lazySingleton
class GetCasualityStatsUseCase extends UseCase<Map<String, dynamic>, NoParams> {
  final CasualityRepository _repository;
  GetCasualityStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getCasualityStats();
  }
}
