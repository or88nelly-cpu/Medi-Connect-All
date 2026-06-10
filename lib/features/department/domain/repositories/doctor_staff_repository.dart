import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';

abstract class DoctorStaffRepository {
  Future<Either<Failure, List<UserModel>>> getDoctorStaff(
    String departmentName,
  );
  Future<Either<Failure, UserModel>> createDoctorStaffMember(UserModel user);
  Future<Either<Failure, UserModel>> updateDoctorStaffMember(UserModel user);
  Future<Either<Failure, void>> deleteDoctorStaffMember(String userId);
}
