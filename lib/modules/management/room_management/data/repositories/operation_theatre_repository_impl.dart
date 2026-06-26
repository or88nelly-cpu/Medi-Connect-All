import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/exceptions.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/modules/management/room_management/data/datasource/operation_theatre_remote_datasource.dart';
import 'package:medi_connect/modules/management/room_management/domain/repositories/operation_theatre_repository.dart';

class OperationTheatreRepositoryImpl implements OperationTheatreRepository {
  final OperationTheatreRemoteDataSource _remoteDataSource;
  OperationTheatreRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>>
  getOperationTheatreStats() async {
    try {
      final res = await _remoteDataSource.getOperationTheatreStats();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
