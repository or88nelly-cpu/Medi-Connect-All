import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/ward_management/domain/repositories/ward_repository.dart';

class GetWardStatsUseCase extends UseCase<Map<String, dynamic>, NoParams> {
  final WardRepository _repository;
  GetWardStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getWardStats();
  }
}
