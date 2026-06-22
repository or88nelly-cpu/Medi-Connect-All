import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/consultation_management/domain/repositories/emrd_repository.dart';

class GetEmrRecordsUseCase
    extends UseCase<List<Map<String, dynamic>>, NoParams> {
  final EmrdRepository _repository;
  GetEmrRecordsUseCase(this._repository);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(NoParams params) {
    return _repository.getEmrRecords();
  }
}
