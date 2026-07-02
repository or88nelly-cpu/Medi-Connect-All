import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/shared/auth/domain/entities/app_user_entity.dart';

abstract class UserDetailsRepository {
  Future<Either<Failure, AppUserEntity>> getFullUserProfile(String userId);
  Future<Either<Failure, void>> updatePatientProfile(String userId, Map<String, dynamic> data);
  Future<Either<Failure, void>> updateEmployeeProfile(String userId, Map<String, dynamic> data);
  Future<Either<Failure, void>> updateDoctorProfile(String userId, Map<String, dynamic> data);
}
