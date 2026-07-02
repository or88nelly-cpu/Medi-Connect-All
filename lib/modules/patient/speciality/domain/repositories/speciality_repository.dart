import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/modules/patient/speciality/domain/entities/speciality_entity.dart';

abstract class SpecialityRepository {
  Future<Either<Failure, List<SpecialityEntity>>> getSpecialities();
  Future<Either<Failure, SpecialityEntity>> createSpeciality(SpecialityEntity speciality);
  Future<Either<Failure, SpecialityEntity>> updateSpeciality(SpecialityEntity speciality);
  Future<Either<Failure, void>> deleteSpeciality(String id);
}
