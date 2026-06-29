import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/exceptions.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/modules/management/consultation_management/data/datasource/emrd_remote_datasource.dart';
import 'package:medi_connect/modules/management/consultation_management/domain/repositories/emrd_repository.dart';

class EmrdRepositoryImpl implements EmrdRepository {
  final EmrdRemoteDataSource _remoteDataSource;
  EmrdRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getEmrdStats() async {
    try {
      final res = await _remoteDataSource.getEmrdStats();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getEmrRecords() async {
    try {
      final res = await _remoteDataSource.getEmrRecords();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
