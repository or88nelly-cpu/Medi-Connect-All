import 'package:injectable/injectable.dart';

abstract class NutritionAndDiabeticsRemoteDataSource {
  Future<Map<String, dynamic>> getNutritionAndDiabeticsStats();
}

@LazySingleton(as: NutritionAndDiabeticsRemoteDataSource)
class NutritionAndDiabeticsRemoteDataSourceImpl
    implements NutritionAndDiabeticsRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getNutritionAndDiabeticsStats() async {
    return {
      'meals_prepared_today': 320,
      'special_diets_prescribed': 45,
      'diabetic_consultations_today': 12,
      'hygiene_score_pct': 98.0,
    };
  }
}
