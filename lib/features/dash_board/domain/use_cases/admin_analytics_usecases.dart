import 'package:fpdart/fpdart.dart';

import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import '../repositories/analytics_repository.dart';

class GetDashboardStatsUseCase extends UseCase<Map<String, dynamic>, NoParams> {
  final AnalyticsRepository _repository;
  const GetDashboardStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) async {
    return _repository.getDashboardStats();
  }
}

class GetAuditLogsUseCase
    extends UseCase<List<Map<String, dynamic>>, NoParams> {
  final AnalyticsRepository _repository;
  const GetAuditLogsUseCase(this._repository);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(
    NoParams params,
  ) async {
    return _repository.getAuditLogs();
  }
}
