import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';

abstract class PatientRepository {
  Future<Either<Failure, List<UserModel>>> getPatients();
  Future<Either<Failure, UserModel>> createPatient(UserModel patient);
  Future<Either<Failure, UserModel>> updatePatient(UserModel patient);
  Future<Either<Failure, void>> deletePatient(String patientId);
  Future<Either<Failure, void>> registerPatientAndSendToMRD(
    UserModel patient,
    Map<String, dynamic> mrdRecord,
  );
}
