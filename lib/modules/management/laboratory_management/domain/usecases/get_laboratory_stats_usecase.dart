import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/laboratory_management/domain/repositories/laboratory_repository.dart';

class GetLaboratoryStatsUseCase
    extends UseCase<Map<String, dynamic>, NoParams> {
  final LaboratoryRepository _repository;
  GetLaboratoryStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getLaboratoryStats();
  }
}
