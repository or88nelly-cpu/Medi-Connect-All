import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/exceptions/exceptions.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/features/departments/icu/data/datasource/icu_remote_datasource.dart';
import 'package:medi_connect/features/departments/icu/domain/repositories/icu_repository.dart';

class IcuRepositoryImpl implements IcuRepository {
  final IcuRemoteDataSource _remoteDataSource;
  IcuRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getIcuStats() async {
    try {
      final res = await _remoteDataSource.getIcuStats();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
