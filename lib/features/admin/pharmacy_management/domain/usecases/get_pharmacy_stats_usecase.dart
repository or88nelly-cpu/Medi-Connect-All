import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/admin/pharmacy_management/domain/repositories/pharmacy_repository.dart';

@lazySingleton
class GetPharmacyStatsUseCase extends UseCase<Map<String, dynamic>, NoParams> {
  final PharmacyRepository _repository;
  GetPharmacyStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getPharmacyStats();
  }
}
