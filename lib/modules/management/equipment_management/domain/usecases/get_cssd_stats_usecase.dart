import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/equipment_management/domain/repositories/cssd_repository.dart';

class GetCssdStatsUseCase extends UseCase<Map<String, dynamic>, NoParams> {
  final CssdRepository _repository;
  GetCssdStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getCssdStats();
  }
}
