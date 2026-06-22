/// Analytics repository interface contract.
library;

import 'package:fpdart/fpdart.dart';

import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/shared/dashboard/domain/entities/analytics_entity.dart';

abstract class AnalyticsRepository {
  Future<Either<Failure, List<AnalyticsEntity>>> getAnalyticsList();
  Future<Either<Failure, Map<String, dynamic>>> getDashboardStats();
  Future<Either<Failure, List<Map<String, dynamic>>>> getAuditLogs();
}
