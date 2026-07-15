library;

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/authentication/domain/entities/user_entity.dart';
import 'package:medi_connect/features/authentication/domain/repositories/auth_repository.dart';

/// Fetches the currently logged-in user profile, if available.








@lazySingleton
class GetCurrentUserUseCase extends UseCase<UserEntity?, NoParams> {
  final AuthRepository _repository;

  const GetCurrentUserUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) {
    return _repository.getCurrentUser();
  }
}
