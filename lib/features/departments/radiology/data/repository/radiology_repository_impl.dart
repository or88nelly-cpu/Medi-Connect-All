import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/exceptions/exceptions.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/features/departments/radiology/data/datasource/radiology_remote_datasource.dart';
import 'package:medi_connect/features/departments/radiology/domain/repositories/radiology_repository.dart';

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
