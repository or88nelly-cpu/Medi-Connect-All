import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/exceptions/exceptions.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/modules/departments/mep_engineer/data/datasource/mep_engineer_remote_datasource.dart';
import 'package:medi_connect/modules/departments/mep_engineer/domain/repositories/mep_engineer_repository.dart';

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
