/// Fetches the currently logged-in user profile, if available.
import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/features/auth/domain/entities/user_entity.dart';
import 'package:medi_connect/features/auth/domain/repositories/auth_repository.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
class GetCurrentUserUseCase extends UseCase<UserEntity?, NoParams> {
  final AuthRepository _repository;

  const GetCurrentUserUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) {
    return _repository.getCurrentUser();
  }
}
