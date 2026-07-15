library;

import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/common/dashboard/domain/entities/analytics_entity.dart';

/// Analytics repository interface contract.







abstract class AnalyticsRepository {
  Future<Either<Failure, List<AnalyticsEntity>>> getAnalyticsList();
  Future<Either<Failure, Map<String, dynamic>>> getDashboardStats();
  Future<Either<Failure, List<Map<String, dynamic>>>> getAuditLogs();
}
