/// Analytics repository interface contract.
import 'package:fpdart/fpdart.dart';

import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/features/dash_board/domain/entities/analytics_entity.dart';


abstract class AnalyticsRepository {
   Future<Either<Failure, List<AnalyticsEntity>>> getAnalyticsList();
  Future<Either<Failure, Map<String, dynamic>>> getDashboardStats();
  Future<Either<Failure, List<Map<String, dynamic>>>> getAuditLogs();
}
