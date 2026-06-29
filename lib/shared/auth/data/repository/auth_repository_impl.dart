/// Repository implementation of the AuthRepository contract.
/// Translates remote exceptions to clean functional Failures.
library;

import 'dart:developer';

import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/constants/app_enum.dart';
import 'package:medi_connect/core/models/exceptions.dart';
import 'package:medi_connect/core/models/failure.dart';

import 'package:medi_connect/core/services/secure_storage_service.dart';
import 'package:medi_connect/shared/auth/data/data_source/auth_remote_datasource.dart';
import 'package:medi_connect/shared/auth/domain/entities/user_entity.dart';
import 'package:medi_connect/shared/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorage;

  AuthRepositoryImpl(this._remoteDataSource, this._secureStorage);

  @override
  Future<Either<Failure, UserEntity>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDataSource.loginWithEmailAndPassword(
        email: email,
        password: password,
      );
      // await _secureStorage.write(
      //   'profile_completion_status',
      //   userModel.c.toString(),
      // );
      await _secureStorage.write(
        'user_role',
        userModel.role.value,
      );
      return Right(userModel);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    String? phoneNumber,
  }) async {
    try {
      log("user details $email $password $name $role $phoneNumber");
      final userModel = await _remoteDataSource.registerWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
        role: role,
        phoneNumber: phoneNumber,
      );
      log("AuthRepositoryImpl: User Model: ${userModel.toJson()}");
      // await _secureStorage.write(
      //   'profile_completion_status',
      //   userModel.profileCompletionStatus.toString(),
      // );
      await _secureStorage.write('user_role', userModel.role.value);
      return Right(userModel);
    } on AuthException catch (e) {
      log("AuthException: ${e.message}");
      return Left(AuthFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      log("ServerException: ${e.message}");
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      log("Exception: ${e.toString()}");
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> verifyOtp({
    required String email,
    required String token,
  }) async {
    try {
      final userModel = await _remoteDataSource.verifyOtp(
        email: email,
        token: token,
      );
      // await _secureStorage.write(
      //   'profile_completion_status',
      //   userModel.profileCompletionStatus.toString(),
      // );
      await _secureStorage.write('user_role', userModel.role.value);
      return Right(userModel);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({required String email}) async {
    try {
      await _remoteDataSource.forgotPassword(email: email);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.resetPassword(newPassword: newPassword);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _secureStorage.delete('profile_completion_status');
      await _secureStorage.delete('user_role');
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final userModel = await _remoteDataSource.getCurrentUser();
      if (userModel != null) {
        // await _secureStorage.write(
        //   'profile_completion_status',
        //   userModel.profileCompletionStatus.toString(),
        // );
        await _secureStorage.write('user_role', userModel.role.value);
      } else {
        await _secureStorage.delete('profile_completion_status');
        await _secureStorage.delete('user_role');
      }
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
