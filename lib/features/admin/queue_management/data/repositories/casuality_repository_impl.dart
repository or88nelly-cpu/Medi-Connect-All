import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/models/exceptions.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/admin/queue_management/data/datasource/casuality_remote_datasource.dart';
import 'package:medi_connect/features/admin/queue_management/domain/repositories/casuality_repository.dart';

@LazySingleton(as: CasualityRepository)
class CasualityRepositoryImpl implements CasualityRepository {
  final CasualityRemoteDataSource _remoteDataSource;
  CasualityRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCasualityStats() async {
    try {
      final res = await _remoteDataSource.getCasualityStats();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
