import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/exceptions/exceptions.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/modules/departments/ward/data/datasource/ward_remote_datasource.dart';
import 'package:medi_connect/modules/departments/ward/domain/repositories/ward_repository.dart';

class WardRepositoryImpl implements WardRepository {
  final WardRemoteDataSource _remoteDataSource;
  WardRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getWardStats() async {
    try {
      final res = await _remoteDataSource.getWardStats();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
