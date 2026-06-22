/// Remote data source interface and implementation for authentication.
/// Integrates with Supabase API for authentication operations.
library;

import 'dart:developer';

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
          .select()
          .eq('id', response.user!.id);

      if (dbProfiles.isEmpty) {
        throw const AuthException("User profile not found in database.");
      }

      final dbProfile = dbProfiles.first as Map<String, dynamic>;
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
          .select()
          .eq('id', response.user!.id);

      Map<String, dynamic> dbProfile = {};
      if (dbProfiles.isNotEmpty) {
        dbProfile = dbProfiles.first as Map<String, dynamic>;
      }

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
          .select()
          .eq('id', user.id);

      if (dbProfiles.isEmpty) {
        return null;
      }

      final dbProfile = dbProfiles.first as Map<String, dynamic>;
      final mergedJson = {...user.toJson(), ...dbProfile};

      return UserModel.fromJson(mergedJson);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
