import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/core/constants/app_table_names.dart';
import 'package:medi_connect/core/constants/app_enum.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/shared/auth/data/models/patient_model.dart';
import 'package:medi_connect/shared/auth/data/models/employee_model.dart';
import 'package:medi_connect/shared/auth/data/models/doctor_model.dart';
import 'package:medi_connect/shared/auth/data/models/app_user_model.dart';
import 'package:medi_connect/shared/auth/domain/entities/app_user_entity.dart';
import 'package:medi_connect/shared/auth/domain/repositories/user_details_repository.dart';

class UserDetailsRepositoryImpl implements UserDetailsRepository {
  final SupabaseService _supabase;

  UserDetailsRepositoryImpl(this._supabase);

  @override
  Future<Either<Failure, AppUserEntity>> getFullUserProfile(String userId) async {
    try {
      // 1. Fetch from users table
      final userResponse = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      final userModel = UserModel.fromJson(userResponse);

      PatientModel? patientModel;
      EmployeeModel? employeeModel;
      DoctorModel? doctorModel;

      final role = userModel.role.value;

      // 2. Fetch specific profiles based on role
      if (role == 'patient') {
        final patientResponse = await _supabase
            .from(AppTableNames.patients)
            .select()
            .eq('user_id', userId)
            .maybeSingle();
        if (patientResponse != null) {
          patientModel = PatientModel.fromJson(patientResponse);
        }
      } else {
        // All staff, doctors, admins are employees
        final employeeResponse = await _supabase
            .from(AppTableNames.employees)
            .select()
            .eq('user_id', userId)
            .maybeSingle();
        if (employeeResponse != null) {
          employeeModel = EmployeeModel.fromJson(employeeResponse);
        }

        if (role == 'doctor') {
          final doctorResponse = await _supabase
              .from(AppTableNames.doctors)
              .select()
              .eq('user_id', userId)
              .maybeSingle();
          if (doctorResponse != null) {
            doctorModel = DoctorModel.fromJson(doctorResponse);
          }
        }
      }

      final appUser = AppUserModel.fromData(
        user: userModel,
        patient: patientModel,
        employee: employeeModel,
        doctor: doctorModel,
      );

      return Right(appUser);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePatientProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _supabase
          .from(AppTableNames.patients)
          .upsert({'user_id': userId, ...data}, onConflict: 'user_id');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateEmployeeProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _supabase
          .from(AppTableNames.employees)
          .upsert({'user_id': userId, ...data}, onConflict: 'user_id');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateDoctorProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _supabase
          .from(AppTableNames.doctors)
          .upsert({'user_id': userId, ...data}, onConflict: 'user_id');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
