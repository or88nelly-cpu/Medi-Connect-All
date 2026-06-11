import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/features/departments/nutrition_and_diabetics/domain/repositories/nutrition_and_diabetics_repository.dart';

class GetNutritionAndDiabeticsStatsUseCase extends UseCase<Map<String, dynamic>, NoParams> {
  final NutritionAndDiabeticsRepository _repository;
  GetNutritionAndDiabeticsStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getNutritionAndDiabeticsStats();
  }
}
