import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/exceptions.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/modules/management/pharmacy_management/data/datasource/pharmacy_remote_datasource.dart';
import 'package:medi_connect/modules/management/pharmacy_management/domain/repositories/pharmacy_repository.dart';

class PharmacyRepositoryImpl implements PharmacyRepository {
  final PharmacyRemoteDataSource _remoteDataSource;
  PharmacyRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getPharmacyStats() async {
    try {
      final res = await _remoteDataSource.getPharmacyStats();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
