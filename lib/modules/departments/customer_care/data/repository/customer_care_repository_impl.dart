import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/exceptions/exceptions.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/modules/departments/customer_care/data/datasource/customer_care_remote_datasource.dart';
import 'package:medi_connect/modules/departments/customer_care/domain/repositories/customer_care_repository.dart';

class CustomerCareRepositoryImpl implements CustomerCareRepository {
  final CustomerCareRemoteDataSource _remoteDataSource;
  CustomerCareRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCustomerCareStats() async {
    try {
      final res = await _remoteDataSource.getCustomerCareStats();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
