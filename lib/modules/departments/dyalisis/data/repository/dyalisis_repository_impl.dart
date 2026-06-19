import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/exceptions/exceptions.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/modules/departments/dyalisis/data/datasource/dyalisis_remote_datasource.dart';
import 'package:medi_connect/modules/departments/dyalisis/domain/repositories/dyalisis_repository.dart';

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
