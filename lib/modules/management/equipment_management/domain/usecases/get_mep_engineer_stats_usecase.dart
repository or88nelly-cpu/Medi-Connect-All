import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/equipment_management/domain/repositories/mep_engineer_repository.dart';

class GetMepEngineerStatsUseCase
    extends UseCase<Map<String, dynamic>, NoParams> {
  final MepEngineerRepository _repository;
  GetMepEngineerStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getMepEngineerStats();
  }
}
