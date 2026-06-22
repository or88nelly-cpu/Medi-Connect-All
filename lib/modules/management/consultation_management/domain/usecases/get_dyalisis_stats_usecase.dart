import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/consultation_management/domain/repositories/dyalisis_repository.dart';

class GetDyalisisStatsUseCase extends UseCase<Map<String, dynamic>, NoParams> {
  final DyalisisRepository _repository;
  GetDyalisisStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getDyalisisStats();
  }
}
