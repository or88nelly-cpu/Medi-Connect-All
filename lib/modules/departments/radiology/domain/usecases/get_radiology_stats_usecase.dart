import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/modules/departments/radiology/domain/repositories/radiology_repository.dart';

class GetRadiologyStatsUseCase extends UseCase<Map<String, dynamic>, NoParams> {
  final RadiologyRepository _repository;
  GetRadiologyStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getRadiologyStats();
  }
}
