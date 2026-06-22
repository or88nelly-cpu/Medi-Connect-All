import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/exceptions.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/modules/management/report_management/data/datasource/management_information_system_remote_datasource.dart';
import 'package:medi_connect/modules/management/report_management/domain/repositories/management_information_system_repository.dart';

class ManagementInformationSystemRepositoryImpl
    implements ManagementInformationSystemRepository {
  final ManagementInformationSystemRemoteDataSource _remoteDataSource;
  ManagementInformationSystemRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>>
  getManagementInformationSystemStats() async {
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
