import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/models/exceptions.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/admin/management/inventory_management/data/datasource/purchase_remote_datasource.dart';
import 'package:medi_connect/features/admin/management/inventory_management/domain/repositories/purchase_repository.dart';

@LazySingleton(as: PurchaseRepository)
class PurchaseRepositoryImpl implements PurchaseRepository {
  final PurchaseRemoteDataSource _remoteDataSource;
  PurchaseRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getPurchaseStats() async {
    try {
      final res = await _remoteDataSource.getPurchaseStats();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
