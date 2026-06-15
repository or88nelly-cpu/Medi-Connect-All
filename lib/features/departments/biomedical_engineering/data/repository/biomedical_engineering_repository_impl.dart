import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/exceptions/exceptions.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/features/departments/biomedical_engineering/data/datasource/biomedical_engineering_remote_datasource.dart';
import 'package:medi_connect/features/departments/biomedical_engineering/domain/repositories/biomedical_engineering_repository.dart';

class BiomedicalEngineeringRepositoryImpl
    implements BiomedicalEngineeringRepository {
  final BiomedicalEngineeringRemoteDataSource _remoteDataSource;
  BiomedicalEngineeringRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>>
  getBiomedicalEngineeringStats() async {
    try {
      final res = await _remoteDataSource.getBiomedicalEngineeringStats();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
