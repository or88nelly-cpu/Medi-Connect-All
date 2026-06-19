import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/exceptions/exceptions.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/modules/departments/fire_safety/data/datasource/fire_safety_remote_datasource.dart';
import 'package:medi_connect/modules/departments/fire_safety/domain/repositories/fire_safety_repository.dart';

class FireSafetyRepositoryImpl implements FireSafetyRepository {
  final FireSafetyRemoteDataSource _remoteDataSource;
  FireSafetyRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getFireSafetyStats() async {
    try {
      final res = await _remoteDataSource.getFireSafetyStats();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
