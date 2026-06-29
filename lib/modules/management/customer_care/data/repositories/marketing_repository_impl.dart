import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/exceptions.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/modules/management/customer_care/data/datasource/marketing_remote_datasource.dart';
import 'package:medi_connect/modules/management/customer_care/domain/repositories/marketing_repository.dart';

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
