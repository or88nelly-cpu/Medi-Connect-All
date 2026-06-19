import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/exceptions/exceptions.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/modules/departments/physio_therapy/data/datasource/physio_therapy_remote_datasource.dart';
import 'package:medi_connect/modules/departments/physio_therapy/domain/repositories/physio_therapy_repository.dart';

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
