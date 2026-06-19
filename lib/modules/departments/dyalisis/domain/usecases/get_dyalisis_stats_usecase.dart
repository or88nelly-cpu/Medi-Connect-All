import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/modules/departments/dyalisis/domain/repositories/dyalisis_repository.dart';

class GetDyalisisStatsUseCase extends UseCase<Map<String, dynamic>, NoParams> {
  final DyalisisRepository _repository;
  GetDyalisisStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getDyalisisStats();
  }
}
