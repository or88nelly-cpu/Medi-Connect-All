import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/room_management/domain/repositories/operation_theatre_repository.dart';

class GetOperationTheatreStatsUseCase
    extends UseCase<Map<String, dynamic>, NoParams> {
  final OperationTheatreRepository _repository;
  GetOperationTheatreStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getOperationTheatreStats();
  }
}
