import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/settings_management/domain/repositories/fire_safety_repository.dart';

class GetFireSafetyStatsUseCase
    extends UseCase<Map<String, dynamic>, NoParams> {
  final FireSafetyRepository _repository;
  GetFireSafetyStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getFireSafetyStats();
  }
}
