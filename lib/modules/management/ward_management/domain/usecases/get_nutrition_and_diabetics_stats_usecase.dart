import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/ward_management/domain/repositories/nutrition_and_diabetics_repository.dart';

class GetNutritionAndDiabeticsStatsUseCase
    extends UseCase<Map<String, dynamic>, NoParams> {
  final NutritionAndDiabeticsRepository _repository;
  GetNutritionAndDiabeticsStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getNutritionAndDiabeticsStats();
  }
}
