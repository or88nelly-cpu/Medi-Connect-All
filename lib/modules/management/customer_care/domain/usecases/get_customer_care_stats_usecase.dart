import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/customer_care/domain/repositories/customer_care_repository.dart';

class GetCustomerCareStatsUseCase
    extends UseCase<Map<String, dynamic>, NoParams> {
  final CustomerCareRepository _repository;
  GetCustomerCareStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getCustomerCareStats();
  }
}
