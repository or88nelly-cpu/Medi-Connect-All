import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/exceptions/exceptions.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/features/departments/cssd/data/datasource/cssd_remote_datasource.dart';
import 'package:medi_connect/features/departments/cssd/domain/repositories/cssd_repository.dart';

class CssdRepositoryImpl implements CssdRepository {
  final CssdRemoteDataSource _remoteDataSource;
  CssdRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCssdStats() async {
    try {
      final res = await _remoteDataSource.getCssdStats();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
