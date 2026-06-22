import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/exceptions.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/modules/management/laboratory_management/data/datasource/laboratory_remote_datasource.dart';
import 'package:medi_connect/modules/management/laboratory_management/domain/repositories/laboratory_repository.dart';

class LaboratoryRepositoryImpl implements LaboratoryRepository {
  final LaboratoryRemoteDataSource _remoteDataSource;
  LaboratoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getLaboratoryStats() async {
    try {
      final res = await _remoteDataSource.getLaboratoryStats();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
