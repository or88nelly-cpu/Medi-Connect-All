import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/settings_management/domain/repositories/information_technology_repository.dart';

class GetInformationTechnologyStatsUseCase
    extends UseCase<Map<String, dynamic>, NoParams> {
  final InformationTechnologyRepository _repository;
  GetInformationTechnologyStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getInformationTechnologyStats();
  }
}
