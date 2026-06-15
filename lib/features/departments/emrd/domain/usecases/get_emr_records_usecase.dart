import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/features/departments/emrd/domain/repositories/emrd_repository.dart';

class GetEmrRecordsUseCase
    extends UseCase<List<Map<String, dynamic>>, NoParams> {
  final EmrdRepository _repository;
  GetEmrRecordsUseCase(this._repository);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(NoParams params) {
    return _repository.getEmrRecords();
  }
}
