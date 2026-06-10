import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/exceptions/exceptions.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/features/department/data/datasource/doctor_staff_remote_datasource.dart';
import 'package:medi_connect/features/department/domain/repositories/doctor_staff_repository.dart';

class DoctorStaffRepositoryImpl implements DoctorStaffRepository {
  final DoctorStaffRemoteDataSource _remoteDataSource;
  DoctorStaffRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<UserModel>>> getDoctorStaff(
    String departmentName,
  ) async {
    try {
      final list = await _remoteDataSource.getDoctorStaff(departmentName);
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> createDoctorStaffMember(
    UserModel user,
  ) async {
    try {
      final res = await _remoteDataSource.createDoctorStaffMember(user);
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateDoctorStaffMember(
    UserModel user,
  ) async {
    try {
      final res = await _remoteDataSource.updateDoctorStaffMember(user);
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDoctorStaffMember(String userId) async {
    try {
      await _remoteDataSource.deleteDoctorStaffMember(userId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
