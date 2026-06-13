import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/exceptions/exceptions.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/features/departments/emrd/data/datasource/emrd_remote_datasource.dart';
import 'package:medi_connect/features/departments/emrd/domain/repositories/emrd_repository.dart';

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
