library;

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/authentication/domain/entities/user_entity.dart';
import 'package:medi_connect/features/authentication/domain/repositories/auth_repository.dart';

/// Executes OTP verification flow in the authentication feature.

class VerifyOtpParams {
  final String email;
  final String token;

  const VerifyOtpParams({required this.email, required this.token});
}

@lazySingleton
class VerifyOtpUseCase extends UseCase<UserEntity, VerifyOtpParams> {
  final AuthRepository _repository;

  const VerifyOtpUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(VerifyOtpParams params) {
    return _repository.verifyOtp(email: params.email, token: params.token);
  }
}
