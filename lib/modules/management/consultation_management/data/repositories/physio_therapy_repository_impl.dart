import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/exceptions.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/modules/management/consultation_management/data/datasource/physio_therapy_remote_datasource.dart';
import 'package:medi_connect/modules/management/consultation_management/domain/repositories/physio_therapy_repository.dart';

class PhysioTherapyRepositoryImpl implements PhysioTherapyRepository {
  final PhysioTherapyRemoteDataSource _remoteDataSource;
  PhysioTherapyRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getPhysioTherapyStats() async {
    try {
      final res = await _remoteDataSource.getPhysioTherapyStats();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
