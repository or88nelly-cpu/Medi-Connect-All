/// Remote data source interface and implementation for authentication.
/// Integrates with Supabase API for authentication operations.
library;

import 'dart:developer';
import 'dart:math' hide log;

import 'package:medi_connect/core/models/exceptions.dart';
import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String role,
    String? phoneNumber,
  });

  Future<UserModel> verifyOtp({required String email, required String token});

  Future<void> forgotPassword({required String email});

  Future<void> resetPassword({required String newPassword});

  Future<void> logout();

  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseService _supabaseService;

  AuthRemoteDataSourceImpl(this._supabaseService);

  @override
  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseService.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw const AuthException("User is empty after sign in.");
      }

      // Fetch profile from users table using Auth User ID
      final List<dynamic> dbProfiles = await _supabaseService.client
          .from('users')
          .select('*, patients(*), doctors(*), employees(*)')
          .eq('id', response.user!.id);

      Map<String, dynamic> dbProfile;
      if (dbProfiles.isEmpty) {
        log("User profile not found in database. Auto-creating profile row.");
        final user = response.user!;
        final insertResponse = await _supabaseService.client.from('users').insert({
          'id': user.id,
          'email': user.email ?? email,
          'phone': user.phone ?? user.userMetadata?['phone'] as String?,
          'role': user.userMetadata?['role'] as String? ?? 'patient',
          'name': user.userMetadata?['name'] as String? ?? user.email?.split('@').first ?? 'User',
          'profile_completion_status': false,
          'status': 'Registered',
        }).select();

        if (insertResponse.isEmpty) {
          throw const ServerException("Failed to auto-create user profile.");
        }
        dbProfile = insertResponse.first;
      } else {
        dbProfile = _mergeProfileDetails(dbProfiles.first as Map<String, dynamic>);
      }

      // Ensure role profile exists in role specific table
      await _createRoleProfile(
        id: response.user!.id,
        role: dbProfile['role'] as String? ?? 'patient',
      );

      final mergedJson = {...response.user!.toJson(), ...dbProfile};

      return UserModel.fromJson(mergedJson);
    } on supabase.AuthException catch (e) {
      throw supabase.AuthException(e.message, code: e.statusCode);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String role,
    String? phoneNumber,
  }) async {
    try {
      log("register attempt $email $name $role $phoneNumber");
      final response = await _supabaseService.auth.signUp(
        email: email,
        password: password,
        data: {'name': name, 'role': role, 'phone': phoneNumber},
      );
      if (response.user == null) {
        throw const AuthException("User is empty after sign up.");
      }

      final authUser = response.user!;
      final authUserId = authUser.id;

      // Check if a profile already exists in the users table using Email or Phone
      dynamic existingRecord;
      var checkQuery = _supabaseService.client.from('users').select();
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        checkQuery = checkQuery.or('email.eq.$email,phone.eq.$phoneNumber');
      } else {
        checkQuery = checkQuery.eq('email', email);
      }
      final List<dynamic> checkResult = await checkQuery;
      if (checkResult.isNotEmpty) {
        existingRecord = checkResult.first;
      }

      Map<String, dynamic> finalProfile;

      if (existingRecord != null) {
        log(
          "Existing profile found. Linking Auth User ID with existing profile.",
        );
        // Link the Auth User ID with the existing profile. Keep existing fields, update ID and status
        final existingEmail = existingRecord['email'] as String? ?? email;
        final updateResponse = await _supabaseService.client
            .from('users')
            .update({'id': authUserId, 'status': 'Registered'})
            .eq('email', existingEmail)
            .select();

        if (updateResponse.isEmpty) {
          throw const ServerException(
            "Failed to update and link user profile.",
          );
        }
        finalProfile = updateResponse.first;
      } else {
        log("No existing profile. Creating a minimal profile record.");
        // Create a minimal profile record with false completion status
        final insertResponse =
            await _supabaseService.client.from('users').insert({
              'id': authUserId,
              'email': email,
              'phone': phoneNumber,
              'role': role,
              'name': name,
              'profile_completion_status': false,
              'status': 'Registered',
            }).select();

        if (insertResponse.isEmpty) {
          throw const ServerException("Failed to create user profile.");
        }
        finalProfile = insertResponse.first;
      }

      // Ensure role profile exists in role specific table
      await _createRoleProfile(id: authUserId, role: role);

      final mergedJson = {...authUser.toJson(), ...finalProfile};

      return UserModel.fromJson(mergedJson);
    } on supabase.AuthException catch (e) {
      log("error supabase signUp $e");
      throw AuthException(e.message, code: e.statusCode);
    } catch (e) {
      log("error during registration $e");
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> verifyOtp({
    required String email,
    required String token,
  }) async {
    try {
      final response = await _supabaseService.auth.verifyOTP(
        email: email,
        token: token,
        type: supabase.OtpType.signup,
      );
      if (response.user == null) {
        throw const AuthException("OTP verification failed.");
      }

      // Fetch profile from users table
      final List<dynamic> dbProfiles = await _supabaseService.client
          .from('users')
          .select('*, patients(*), doctors(*), employees(*)')
          .eq('id', response.user!.id);

      Map<String, dynamic> dbProfile = {};
      if (dbProfiles.isEmpty) {
        log("User profile not found in database during OTP. Auto-creating.");
        final user = response.user!;
        final insertResponse = await _supabaseService.client.from('users').insert({
          'id': user.id,
          'email': user.email ?? email,
          'phone': user.phone ?? user.userMetadata?['phone'] as String?,
          'role': user.userMetadata?['role'] as String? ?? 'patient',
          'name': user.userMetadata?['name'] as String? ?? user.email?.split('@').first ?? 'User',
          'profile_completion_status': false,
          'status': 'Registered',
        }).select();

        if (insertResponse.isNotEmpty) {
          dbProfile = insertResponse.first;
        }
      } else {
        dbProfile = _mergeProfileDetails(dbProfiles.first as Map<String, dynamic>);
      }

      // Ensure role profile exists in role specific table
      await _createRoleProfile(
        id: response.user!.id,
        role: dbProfile['role'] as String? ?? 'patient',
      );

      final mergedJson = {...response.user!.toJson(), ...dbProfile};

      return UserModel.fromJson(mergedJson);
    } on supabase.AuthException catch (e) {
      throw AuthException(e.message, code: e.statusCode);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await _supabaseService.auth.resetPasswordForEmail(email);
    } on supabase.AuthException catch (e) {
      throw AuthException(e.message, code: e.statusCode);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> resetPassword({required String newPassword}) async {
    try {
      await _supabaseService.auth.updateUser(
        supabase.UserAttributes(password: newPassword),
      );
    } on supabase.AuthException catch (e) {
      throw AuthException(e.message, code: e.statusCode);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _supabaseService.auth.signOut();
    } on supabase.AuthException catch (e) {
      throw AuthException(e.message, code: e.statusCode);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabaseService.currentUser;
      if (user == null) return null;

      // Fetch profile from users table
      final List<dynamic> dbProfiles = await _supabaseService.client
          .from('users')
          .select('*, patients(*), doctors(*), employees(*)')
          .eq('id', user.id);

      Map<String, dynamic> dbProfile;
      if (dbProfiles.isEmpty) {
        log("User profile not found in database during getCurrentUser. Auto-creating.");
        final insertResponse = await _supabaseService.client.from('users').insert({
          'id': user.id,
          'email': user.email ?? '',
          'phone': user.phone ?? user.userMetadata?['phone'] as String?,
          'role': user.userMetadata?['role'] as String? ?? 'patient',
          'name': user.userMetadata?['name'] as String? ?? user.email?.split('@').first ?? 'User',
          'profile_completion_status': false,
          'status': 'Registered',
        }).select();

        if (insertResponse.isEmpty) {
          return null;
        }
        dbProfile = insertResponse.first;
      } else {
        dbProfile = _mergeProfileDetails(dbProfiles.first as Map<String, dynamic>);
      }

      // Ensure role profile exists in role specific table
      await _createRoleProfile(
        id: user.id,
        role: dbProfile['role'] as String? ?? 'patient',
      );

      final mergedJson = {...user.toJson(), ...dbProfile};

      return UserModel.fromJson(mergedJson);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> _createRoleProfile({
    required String id,
    required String role,
  }) async {
    try {
      if (role == 'patient') {
        final randomNum = (Random().nextInt(9000000) + 1000000).toString();
        await _supabaseService.client.from('patients').insert({
          'id': id,
          'patient_id': 'CCH25-$randomNum',
        });
      } else if (role == 'doctor') {
        final randomNum = (Random().nextInt(9000) + 1000).toString();
        await _supabaseService.client.from('doctors').insert({
          'id': id,
          'medical_registration_number': 'REG-$randomNum',
        });
      } else if (role == 'staff') {
        final randomNum = (Random().nextInt(9000) + 1000).toString();
        await _supabaseService.client.from('employees').insert({
          'id': id,
          'employee_id': 'EMP-$randomNum',
        });
      } else if (role == 'admin') {
        await _supabaseService.client.from('admins').insert({
          'id': id,
          'access_level': 'Super Admin',
        });
      }
    } catch (e) {
      log("Role profile insert skipped or already exists: $e");
    }
  }

  Map<String, dynamic> _mergeProfileDetails(Map<String, dynamic> rawProfile) {
    final map = Map<String, dynamic>.from(rawProfile);
    
    // Merge patient specific profile if present
    final patientJson = map.remove('patients');
    if (patientJson is List && patientJson.isNotEmpty) {
      map.addAll(patientJson.first as Map<String, dynamic>);
    } else if (patientJson is Map<String, dynamic>) {
      map.addAll(patientJson);
    }
    
    // Merge doctor specific profile if present
    final doctorJson = map.remove('doctors');
    if (doctorJson is List && doctorJson.isNotEmpty) {
      map.addAll(doctorJson.first as Map<String, dynamic>);
    } else if (doctorJson is Map<String, dynamic>) {
      map.addAll(doctorJson);
    }

    // Merge employee specific profile if present
    final employeeJson = map.remove('employees');
    if (employeeJson is List && employeeJson.isNotEmpty) {
      map.addAll(employeeJson.first as Map<String, dynamic>);
    } else if (employeeJson is Map<String, dynamic>) {
      map.addAll(employeeJson);
    }

    // Map DB snake_case fields back to CamelCase keys for UserModel compatibility
    if (map.containsKey('patient_id')) {
      map['patientId'] = map['patient_id'];
    }
    if (map.containsKey('phone')) {
      map['phoneNumber'] = map['phone'];
    }
    if (map.containsKey('profile_image')) {
      map['profileImage'] = map['profile_image'];
    }
    if (map.containsKey('profile_completion_status')) {
      map['profileCompletionStatus'] = map['profile_completion_status'];
    }
    if (map.containsKey('date_of_birth')) {
      map['dateOfBirth'] = map['date_of_birth'];
    }
    if (map.containsKey('insurance_number')) {
      map['insuranceNumber'] = map['insurance_number'];
    }
    if (map.containsKey('medical_registration_number')) {
      map['medicalRegistrationNumber'] = map['medical_registration_number'];
    }
    if (map.containsKey('employee_id')) {
      map['employeeId'] = map['employee_id'];
    }
    if (map.containsKey('joining_date')) {
      map['joiningDate'] = map['joining_date'];
    }
    if (map.containsKey('staff_role')) {
      map['staffRole'] = map['staff_role'];
    }
    if (map.containsKey('profile_completed')) {
      map['profileCompletionStatus'] = map['profile_completed'];
    }
    if (map.containsKey('onboarding_step')) {
      map['onboardingStep'] = map['onboarding_step'];
    }

    return map;
  }
}
