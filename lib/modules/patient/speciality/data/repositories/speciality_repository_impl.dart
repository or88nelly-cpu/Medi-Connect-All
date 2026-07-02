import 'dart:developer' as developer;
import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/core/constants/app_table_names.dart';
import 'package:medi_connect/modules/patient/speciality/data/models/speciality_model.dart';
import 'package:medi_connect/modules/patient/speciality/domain/entities/speciality_entity.dart';
import 'package:medi_connect/modules/patient/speciality/domain/repositories/speciality_repository.dart';

class SpecialityRepositoryImpl implements SpecialityRepository {
  final SupabaseService _supabase;

  SpecialityRepositoryImpl(this._supabase);

  @override
  Future<Either<Failure, List<SpecialityEntity>>> getSpecialities() async {
    try {
      final response = await _supabase
          .from(AppTableNames.specialities)
          .select()
          .order('name', ascending: true);

      final List<dynamic> data = response as List<dynamic>;
      final list = data
          .map((json) => SpecialityModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return Right(list);
    } catch (e, stackTrace) {
      developer.log(
        "Exception in getSpecialities",
        error: e.toString(),
        stackTrace: stackTrace,
        name: "SpecialityRepository",
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SpecialityEntity>> createSpeciality(
    SpecialityEntity speciality,
  ) async {
    try {
      final model = SpecialityModel.fromEntity(speciality);
      final response = await _supabase
          .from(AppTableNames.specialities)
          .insert(model.toJson())
          .select()
          .single();
      return Right(SpecialityModel.fromJson(response as Map<String, dynamic>));
    } catch (e, stackTrace) {
      developer.log(
        "Exception in createSpeciality",
        error: e,
        stackTrace: stackTrace,
        name: "SpecialityRepository",
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SpecialityEntity>> updateSpeciality(
    SpecialityEntity speciality,
  ) async {
    try {
      final model = SpecialityModel.fromEntity(speciality);
      final response = await _supabase
          .from(AppTableNames.specialities)
          .update(model.toJson())
          .eq('id', model.id)
          .select()
          .single();
      return Right(SpecialityModel.fromJson(response as Map<String, dynamic>));
    } catch (e, stackTrace) {
      developer.log(
        "Exception in updateSpeciality",
        error: e,
        stackTrace: stackTrace,
        name: "SpecialityRepository",
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSpeciality(String id) async {
    try {
      await _supabase.from(AppTableNames.specialities).delete().eq('id', id);
      return const Right(null);
    } catch (e, stackTrace) {
      developer.log(
        "Exception in deleteSpeciality",
        error: e,
        stackTrace: stackTrace,
        name: "SpecialityRepository",
      );
      return Left(ServerFailure(e.toString()));
    }
  }
}
