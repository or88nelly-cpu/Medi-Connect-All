library;

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/authentication/domain/repositories/auth_repository.dart';

/// Resets the user's password in the authentication feature.

@lazySingleton
class ResetPasswordUseCase extends UseCase<void, String> {
  final AuthRepository _repository;

  const ResetPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(String params) {
    return _repository.resetPassword(newPassword: params);
  }
}
