import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/billing_management/domain/repositories/finance_repository.dart';

class GetFinanceStatsUseCase extends UseCase<Map<String, dynamic>, NoParams> {
  final FinanceRepository _repository;
  GetFinanceStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getFinanceStats();
  }
}
