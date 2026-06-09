/// Base interface for all business logic Use Cases in the Domain layer.
/// Forces consistent input (Params) and output (Either Failure or Success Type).
import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';


abstract class UseCase<Type, Params> {
  const UseCase();

  /// Executes the core business logic of the use case.
  Future<Either<Failure, Type>> call(Params params);
}

/// Fallback params when a usecase does not require arguments.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
