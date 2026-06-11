import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/exceptions/exceptions.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/features/departments/purchase/data/datasource/purchase_remote_datasource.dart';
import 'package:medi_connect/features/departments/purchase/domain/repositories/purchase_repository.dart';

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
