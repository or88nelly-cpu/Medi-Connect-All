import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/pharmacy_management/domain/repositories/pharmacy_repository.dart';

class GetPharmacyStatsUseCase extends UseCase<Map<String, dynamic>, NoParams> {
  final PharmacyRepository _repository;
  GetPharmacyStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getPharmacyStats();
  }
}
