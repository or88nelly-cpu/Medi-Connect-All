import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/exceptions/exceptions.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/features/departments/management_information_system/data/datasource/management_information_system_remote_datasource.dart';
import 'package:medi_connect/features/departments/management_information_system/domain/repositories/management_information_system_repository.dart';

class ManagementInformationSystemRepositoryImpl implements ManagementInformationSystemRepository {
  final ManagementInformationSystemRemoteDataSource _remoteDataSource;
  ManagementInformationSystemRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getManagementInformationSystemStats() async {
    try {
      final res = await _remoteDataSource.getManagementInformationSystemStats();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
