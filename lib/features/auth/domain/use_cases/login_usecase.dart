/// Executes login flow in the authentication feature.
library;

import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import 'package:medi_connect/core/usecases/usecase.dart';

class LoginParams {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});
}

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
