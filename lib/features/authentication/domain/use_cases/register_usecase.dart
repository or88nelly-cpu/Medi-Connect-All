library;

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/constants/app_enum.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/authentication/domain/entities/user_entity.dart';
import 'package:medi_connect/features/authentication/domain/repositories/auth_repository.dart';

/// Executes registration flow in the authentication feature.









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

@lazySingleton
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
