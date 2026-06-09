/// Signs out the user session from the application.
import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import '../repositories/auth_repository.dart';
import 'package:medi_connect/core/usecases/usecase.dart';

class LogoutUseCase extends UseCase<void, NoParams> {
  final AuthRepository _repository;

  const LogoutUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return _repository.logout();
  }
}
