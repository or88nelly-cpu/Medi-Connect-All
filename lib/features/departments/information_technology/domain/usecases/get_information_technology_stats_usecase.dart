import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/features/departments/information_technology/domain/repositories/information_technology_repository.dart';

class GetInformationTechnologyStatsUseCase extends UseCase<Map<String, dynamic>, NoParams> {
  final InformationTechnologyRepository _repository;
  GetInformationTechnologyStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getInformationTechnologyStats();
  }
}
