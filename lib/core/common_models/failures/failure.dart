/// Failure definitions representing errors in the Domain layer.
/// Used with the Either pattern for predictable, functional error handling.
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Represents failure from backend or HTTP server.
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}

/// Represents failure during local database or cache operations.
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Represents connection/offline network errors.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = "No Internet Connection"]);
}

/// Represents failure during authentication flow.
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});
}

/// Represents input/field validation errors.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
