import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/exceptions/exceptions.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/features/departments/marketing/data/datasource/marketing_remote_datasource.dart';
import 'package:medi_connect/features/departments/marketing/domain/repositories/marketing_repository.dart';

class MarketingRepositoryImpl implements MarketingRepository {
  final MarketingRemoteDataSource _remoteDataSource;
  MarketingRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getMarketingStats() async {
    try {
      final res = await _remoteDataSource.getMarketingStats();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
