import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/shared/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase extends UseCase<void, String> {
  final AuthRepository _repository;

  const ForgotPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(String params) {
    return _repository.forgotPassword(email: params);
  }
}
