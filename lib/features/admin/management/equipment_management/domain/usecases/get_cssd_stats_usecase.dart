import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/admin/management/equipment_management/domain/repositories/cssd_repository.dart';

@lazySingleton
class GetCssdStatsUseCase extends UseCase<Map<String, dynamic>, NoParams> {
  final CssdRepository _repository;
  GetCssdStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getCssdStats();
  }
}
