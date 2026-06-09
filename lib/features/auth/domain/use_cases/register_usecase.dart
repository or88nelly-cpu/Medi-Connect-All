/// Executes registration flow in the authentication feature.
import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import 'package:medi_connect/core/usecases/usecase.dart';

class RegisterParams {
  final String email;
  final String password;
  final String name;
  final String role;
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
