import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/exceptions/exceptions.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/features/departments/casuality/data/datasource/casuality_remote_datasource.dart';
import 'package:medi_connect/features/departments/casuality/domain/repositories/casuality_repository.dart';

class CasualityRepositoryImpl implements CasualityRepository {
  final CasualityRemoteDataSource _remoteDataSource;
  CasualityRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCasualityStats() async {
    try {
      final res = await _remoteDataSource.getCasualityStats();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
