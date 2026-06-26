import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/staff_management/domain/repositories/human_resource_repository.dart';

class GetHumanResourceStatsUseCase
    extends UseCase<Map<String, dynamic>, NoParams> {
  final HumanResourceRepository _repository;
  GetHumanResourceStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getHumanResourceStats();
  }
}
