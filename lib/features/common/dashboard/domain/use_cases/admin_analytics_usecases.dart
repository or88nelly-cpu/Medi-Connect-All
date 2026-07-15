import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/common/dashboard/domain/repositories/analytics_repository.dart';

@lazySingleton
class GetDashboardStatsUseCase extends UseCase<Map<String, dynamic>, NoParams> {
  final AnalyticsRepository _repository;
  const GetDashboardStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) async {
    return _repository.getDashboardStats();
  }
}

@lazySingleton
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
