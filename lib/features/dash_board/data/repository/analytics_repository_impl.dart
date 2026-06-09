/// Implementation of AnalyticsRepository interface contract.
import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/exceptions/exceptions.dart';

import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/features/dash_board/data/data_source/analytics_remote_datasource.dart';
import '../../domain/entities/analytics_entity.dart';
import '../../domain/repositories/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDataSource _remoteDataSource;

  AnalyticsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<AnalyticsEntity>>> getAnalyticsList() async {
    try {
      final models = await _remoteDataSource.getAnalyticsList();
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getDashboardStats() async {
    try {
      final stats = await _remoteDataSource.getDashboardStats();
      return Right(stats);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAuditLogs() async {
    try {
      final logs = await _remoteDataSource.getAuditLogs();
      return Right(logs);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
