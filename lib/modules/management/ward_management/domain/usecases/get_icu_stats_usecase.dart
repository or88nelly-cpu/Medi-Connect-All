import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/ward_management/domain/repositories/icu_repository.dart';

class GetIcuStatsUseCase extends UseCase<Map<String, dynamic>, NoParams> {
  final IcuRepository _repository;
  GetIcuStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getIcuStats();
  }
}
