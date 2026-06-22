import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/exceptions.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/modules/management/equipment_management/data/datasource/mep_engineer_remote_datasource.dart';
import 'package:medi_connect/modules/management/equipment_management/domain/repositories/mep_engineer_repository.dart';

class MepEngineerRepositoryImpl implements MepEngineerRepository {
  final MepEngineerRemoteDataSource _remoteDataSource;
  MepEngineerRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getMepEngineerStats() async {
    try {
      final res = await _remoteDataSource.getMepEngineerStats();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
