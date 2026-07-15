import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/admin/management/customer_care/domain/repositories/marketing_repository.dart';

@lazySingleton
class GetMarketingStatsUseCase extends UseCase<Map<String, dynamic>, NoParams> {
  final MarketingRepository _repository;
  GetMarketingStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getMarketingStats();
  }
}
