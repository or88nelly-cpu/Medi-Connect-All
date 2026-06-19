import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/modules/departments/emrd/domain/repositories/emrd_repository.dart';

class GetEmrdStatsUseCase extends UseCase<Map<String, dynamic>, NoParams> {
  final EmrdRepository _repository;
  GetEmrdStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getEmrdStats();
  }
}
