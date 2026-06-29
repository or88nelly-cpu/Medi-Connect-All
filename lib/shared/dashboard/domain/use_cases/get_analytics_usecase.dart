/// Executes fetching analytics data.
library;

import 'package:fpdart/fpdart.dart';
// import 'package:core/core.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/shared/dashboard/domain/entities/analytics_entity.dart';
import 'package:medi_connect/shared/dashboard/domain/repositories/analytics_repository.dart';

class GetAnalyticsUseCase extends UseCase<List<AnalyticsEntity>, NoParams> {
  final AnalyticsRepository _repository;

  const GetAnalyticsUseCase(this._repository);

  @override
  Future<Either<Failure, List<AnalyticsEntity>>> call(NoParams params) {
    return _repository.getAnalyticsList();
  }
}
