import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/features/departments/biomedical_engineering/domain/repositories/biomedical_engineering_repository.dart';

class GetBiomedicalEngineeringStatsUseCase
    extends UseCase<Map<String, dynamic>, NoParams> {
  final BiomedicalEngineeringRepository _repository;
  GetBiomedicalEngineeringStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getBiomedicalEngineeringStats();
  }
}
