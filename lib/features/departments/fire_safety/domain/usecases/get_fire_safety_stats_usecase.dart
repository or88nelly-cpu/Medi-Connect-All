import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/features/departments/fire_safety/domain/repositories/fire_safety_repository.dart';

class GetFireSafetyStatsUseCase
    extends UseCase<Map<String, dynamic>, NoParams> {
  final FireSafetyRepository _repository;
  GetFireSafetyStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getFireSafetyStats();
  }
}
