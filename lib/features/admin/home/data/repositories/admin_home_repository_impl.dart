import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/models/exceptions.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/services/app_logger.dart';
import 'package:medi_connect/features/admin/home/data/datasources/admin_home_remote_data_source.dart';
import 'package:medi_connect/features/admin/home/domain/entities/admin_dashboard_module_entity.dart';
import 'package:medi_connect/features/admin/home/domain/repositories/admin_home_repository.dart';

/// Repository implementation for Admin Control Center operations.
@LazySingleton(as: AdminHomeRepository)
class AdminHomeRepositoryImpl implements AdminHomeRepository {
  final AdminHomeRemoteDataSource remoteDataSource;

  AdminHomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<AdminDashboardModuleEntity>>>
  getDashboardModules() async {
    try {
      AppLogger.info('AdminHomeRepositoryImpl: Fetching dashboard modules...');
      final modules = await remoteDataSource.getDashboardModules();
      return Right(modules);
    } on ServerException catch (e, stack) {
      AppLogger.error('ServerException in AdminHomeRepositoryImpl', e, stack);
      return Left(ServerFailure(e.message));
    } catch (e, stack) {
      AppLogger.error(
        'Unexpected exception in AdminHomeRepositoryImpl',
        e,
        stack,
      );
      return Left(UnknownFailure(e.toString()));
    }
  }
}
