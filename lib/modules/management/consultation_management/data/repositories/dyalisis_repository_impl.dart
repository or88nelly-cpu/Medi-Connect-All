import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/exceptions.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/modules/management/consultation_management/data/datasource/dyalisis_remote_datasource.dart';
import 'package:medi_connect/modules/management/consultation_management/domain/repositories/dyalisis_repository.dart';

class DyalisisRepositoryImpl implements DyalisisRepository {
  final DyalisisRemoteDataSource _remoteDataSource;
  DyalisisRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getDyalisisStats() async {
    try {
      final res = await _remoteDataSource.getDyalisisStats();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
