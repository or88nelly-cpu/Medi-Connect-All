import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/exceptions.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/modules/management/inventory_management/data/datasource/general_store_remote_datasource.dart';
import 'package:medi_connect/modules/management/inventory_management/domain/repositories/general_store_repository.dart';

class GeneralStoreRepositoryImpl implements GeneralStoreRepository {
  final GeneralStoreRemoteDataSource _remoteDataSource;
  GeneralStoreRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getGeneralStoreStats() async {
    try {
      final res = await _remoteDataSource.getGeneralStoreStats();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
