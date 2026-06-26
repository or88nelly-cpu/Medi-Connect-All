/// Authentication repository interface contract.
/// Must be implemented in the Data layer.
library;

import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';

import 'package:medi_connect/shared/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  /// Sign in user using email and password.
  Future<Either<Failure, UserEntity>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Register user using email, password, and metadata (like role, name, phone).
  Future<Either<Failure, UserEntity>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String role,
    String? phoneNumber,
  });

  /// Verify OTP code sent to user.
  Future<Either<Failure, UserEntity>> verifyOtp({
    required String email,
    required String token,
  });

  /// Send password reset code.
  Future<Either<Failure, void>> forgotPassword({required String email});

  /// Set a new password for the current user.
  Future<Either<Failure, void>> resetPassword({required String newPassword});

  /// Sign out the current user session.
  Future<Either<Failure, void>> logout();

  /// Retrieve the currently authenticated user entity.
  Future<Either<Failure, UserEntity?>> getCurrentUser();
}
