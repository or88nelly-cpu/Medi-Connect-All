library;

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/common/dashboard/domain/entities/analytics_entity.dart';
import 'package:medi_connect/features/common/dashboard/domain/repositories/analytics_repository.dart';

/// Executes fetching analytics data.



// 





@lazySingleton
class GetAnalyticsUseCase extends UseCase<List<AnalyticsEntity>, NoParams> {
  final AnalyticsRepository _repository;

  const GetAnalyticsUseCase(this._repository);

  @override
  Future<Either<Failure, List<AnalyticsEntity>>> call(NoParams params) {
    return _repository.getAnalyticsList();
  }
}
