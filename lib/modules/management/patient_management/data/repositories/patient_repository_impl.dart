import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/exceptions.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/modules/management/patient_management/data/datasource/patient_remote_datasource.dart';
import 'package:medi_connect/modules/management/patient_management/domain/repositories/patient_repository.dart';

class PatientRepositoryImpl implements PatientRepository {
  final PatientRemoteDataSource _remoteDataSource;
  PatientRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<UserModel>>> getPatients() async {
    try {
      final list = await _remoteDataSource.getPatients();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> createPatient(UserModel patient) async {
    try {
      final res = await _remoteDataSource.createPatient(patient);
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updatePatient(UserModel patient) async {
    try {
      final res = await _remoteDataSource.updatePatient(patient);
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePatient(String patientId) async {
    try {
      await _remoteDataSource.deletePatient(patientId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerPatientAndSendToMRD(
    UserModel patient,
    Map<String, dynamic> mrdRecord,
  ) async {
    try {
      await _remoteDataSource.createPatient(patient);
      await _remoteDataSource.sendToMRD(mrdRecord);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
