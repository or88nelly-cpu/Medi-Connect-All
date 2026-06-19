import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/modules/departments/marketing/domain/repositories/marketing_repository.dart';

class GetMarketingStatsUseCase extends UseCase<Map<String, dynamic>, NoParams> {
  final MarketingRepository _repository;
  GetMarketingStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getMarketingStats();
  }
}
