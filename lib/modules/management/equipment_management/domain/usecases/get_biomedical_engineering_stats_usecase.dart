import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/equipment_management/domain/repositories/biomedical_engineering_repository.dart';

class GetBiomedicalEngineeringStatsUseCase
    extends UseCase<Map<String, dynamic>, NoParams> {
  final BiomedicalEngineeringRepository _repository;
  GetBiomedicalEngineeringStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getBiomedicalEngineeringStats();
  }
}
