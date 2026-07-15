import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/admin/management/consultation_management/domain/repositories/emrd_repository.dart';

@lazySingleton
class GetEmrdStatsUseCase extends UseCase<Map<String, dynamic>, NoParams> {
  final EmrdRepository _repository;
  GetEmrdStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getEmrdStats();
  }
}
