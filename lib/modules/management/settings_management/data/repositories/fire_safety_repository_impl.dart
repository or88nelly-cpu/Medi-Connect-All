import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/exceptions.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/modules/management/settings_management/data/datasource/fire_safety_remote_datasource.dart';
import 'package:medi_connect/modules/management/settings_management/domain/repositories/fire_safety_repository.dart';

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
