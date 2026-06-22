import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/exceptions.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/modules/management/laboratory_management/data/datasource/radiology_remote_datasource.dart';
import 'package:medi_connect/modules/management/laboratory_management/domain/repositories/radiology_repository.dart';

class RadiologyRepositoryImpl implements RadiologyRepository {
  final RadiologyRemoteDataSource _remoteDataSource;
  RadiologyRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getRadiologyStats() async {
    try {
      final res = await _remoteDataSource.getRadiologyStats();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
