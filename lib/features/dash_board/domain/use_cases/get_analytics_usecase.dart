/// Executes fetching analytics data.
import 'package:fpdart/fpdart.dart';
// import 'package:core/core.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import '../entities/analytics_entity.dart';
import '../repositories/analytics_repository.dart';

class GetAnalyticsUseCase extends UseCase<List<AnalyticsEntity>, NoParams> {
  final AnalyticsRepository _repository;

  const GetAnalyticsUseCase(this._repository);

  @override
  Future<Either<Failure, List<AnalyticsEntity>>> call(NoParams params) {
    return _repository.getAnalyticsList();
  }
}
