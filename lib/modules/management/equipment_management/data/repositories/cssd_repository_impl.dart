import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/exceptions.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/modules/management/equipment_management/data/datasource/cssd_remote_datasource.dart';
import 'package:medi_connect/modules/management/equipment_management/domain/repositories/cssd_repository.dart';

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
