import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/exceptions/exceptions.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/modules/departments/nursing/data/datasource/nursing_remote_datasource.dart';
import 'package:medi_connect/modules/departments/nursing/domain/repositories/nursing_repository.dart';

class NursingRepositoryImpl implements NursingRepository {
  final NursingRemoteDataSource _remoteDataSource;
  NursingRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getNursingStats() async {
    try {
      final res = await _remoteDataSource.getNursingStats();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
