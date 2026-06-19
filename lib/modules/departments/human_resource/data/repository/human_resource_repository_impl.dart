import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/exceptions/exceptions.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/modules/departments/human_resource/data/datasource/human_resource_remote_datasource.dart';
import 'package:medi_connect/modules/departments/human_resource/domain/repositories/human_resource_repository.dart';

class HumanResourceRepositoryImpl implements HumanResourceRepository {
  final HumanResourceRemoteDataSource _remoteDataSource;
  HumanResourceRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getHumanResourceStats() async {
    try {
      final res = await _remoteDataSource.getHumanResourceStats();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
