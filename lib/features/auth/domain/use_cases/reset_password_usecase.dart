/// Resets the user's password in the authentication feature.
import 'package:fpdart/fpdart.dart';

import 'package:medi_connect/core/common_models/failures/failure.dart';
import '../repositories/auth_repository.dart';
import 'package:medi_connect/core/usecases/usecase.dart';

class ResetPasswordUseCase extends UseCase<void, String> {
  final AuthRepository _repository;

  const ResetPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(String params) {
    return _repository.resetPassword(newPassword: params);
  }
}
