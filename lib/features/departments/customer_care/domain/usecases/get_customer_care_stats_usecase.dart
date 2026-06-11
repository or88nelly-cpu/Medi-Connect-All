import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/features/departments/customer_care/domain/repositories/customer_care_repository.dart';

class GetCustomerCareStatsUseCase extends UseCase<Map<String, dynamic>, NoParams> {
  final CustomerCareRepository _repository;
  GetCustomerCareStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getCustomerCareStats();
  }
}
