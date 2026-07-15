import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/models/exceptions.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/admin/equipment_management/data/datasource/biomedical_engineering_remote_datasource.dart';
import 'package:medi_connect/features/admin/equipment_management/domain/repositories/biomedical_engineering_repository.dart';

@LazySingleton(as: BiomedicalEngineeringRepository)
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
