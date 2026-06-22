import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/inventory_management/domain/repositories/purchase_repository.dart';

class GetPurchaseStatsUseCase extends UseCase<Map<String, dynamic>, NoParams> {
  final PurchaseRepository _repository;
  GetPurchaseStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getPurchaseStats();
  }
}
