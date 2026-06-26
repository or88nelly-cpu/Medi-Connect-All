import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/exceptions.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/modules/management/settings_management/data/datasource/information_technology_remote_datasource.dart';
import 'package:medi_connect/modules/management/settings_management/domain/repositories/information_technology_repository.dart';

class InformationTechnologyRepositoryImpl
    implements InformationTechnologyRepository {
  final InformationTechnologyRemoteDataSource _remoteDataSource;
  InformationTechnologyRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>>
  getInformationTechnologyStats() async {
    try {
      final res = await _remoteDataSource.getInformationTechnologyStats();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
