import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/models/exceptions.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/admin/management/billing_management/data/datasource/finance_remote_datasource.dart';
import 'package:medi_connect/features/admin/management/billing_management/domain/repositories/finance_repository.dart';

@LazySingleton(as: FinanceRepository)
class FinanceRepositoryImpl implements FinanceRepository {
  final FinanceRemoteDataSource _remoteDataSource;
  FinanceRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getFinanceStats() async {
    try {
      final res = await _remoteDataSource.getFinanceStats();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
