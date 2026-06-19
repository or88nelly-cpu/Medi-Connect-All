import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/exceptions/exceptions.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/modules/departments/nutrition_and_diabetics/data/datasource/nutrition_and_diabetics_remote_datasource.dart';
import 'package:medi_connect/modules/departments/nutrition_and_diabetics/domain/repositories/nutrition_and_diabetics_repository.dart';

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
