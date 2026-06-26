import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/exceptions.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/modules/management/ward_management/data/datasource/nutrition_and_diabetics_remote_datasource.dart';
import 'package:medi_connect/modules/management/ward_management/domain/repositories/nutrition_and_diabetics_repository.dart';

class NutritionAndDiabeticsRepositoryImpl
    implements NutritionAndDiabeticsRepository {
  final NutritionAndDiabeticsRemoteDataSource _remoteDataSource;
  NutritionAndDiabeticsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>>
  getNutritionAndDiabeticsStats() async {
    try {
      final res = await _remoteDataSource.getNutritionAndDiabeticsStats();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
