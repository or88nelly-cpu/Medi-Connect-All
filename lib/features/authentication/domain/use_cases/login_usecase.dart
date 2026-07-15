library;

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/authentication/domain/entities/user_entity.dart';
import 'package:medi_connect/features/authentication/domain/repositories/auth_repository.dart';

/// Executes login flow in the authentication feature.

class LoginParams {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});
}

@lazySingleton
class LoginUseCase extends UseCase<UserEntity, LoginParams> {
  final AuthRepository _repository;

  const LoginUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return _repository.loginWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}
