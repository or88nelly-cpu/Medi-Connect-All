
import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/features/auth/domain/repositories/auth_repository.dart';


class ForgotPasswordUseCase extends UseCase<void, String> {
  final AuthRepository _repository;

  const ForgotPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(String params) {
    return _repository.forgotPassword(email: params);
  }
}
