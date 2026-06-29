/// Executes registration flow in the authentication feature.
library;

import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/constants/app_enum.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/shared/auth/domain/entities/user_entity.dart';
import 'package:medi_connect/shared/auth/domain/repositories/auth_repository.dart';
import 'package:medi_connect/core/functions/usecase.dart';

class RegisterParams {
  final String email;
  final String password;
  final String name;
  final UserRole role;
  final String? phoneNumber;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.name,
    required this.role,
    this.phoneNumber,
  });
}

class RegisterUseCase extends UseCase<UserEntity, RegisterParams> {
  final AuthRepository _repository;

  const RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) {
    return _repository.registerWithEmailAndPassword(
      email: params.email,
      password: params.password,
      name: params.name,
      role: params.role,
      phoneNumber: params.phoneNumber,
    );
  }
}
