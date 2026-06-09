/// Local data-layer exceptions that will be caught and converted
/// to Failure objects in the repository implementations.

class ServerException implements Exception {
  final String message;
  final String? code;

  const ServerException(this.message, {this.code});

  @override
  String toString() => "ServerException(message: $message, code: $code)";
}

class CacheException implements Exception {
  final String message;

  const CacheException(this.message);

  @override
  String toString() => "CacheException(message: $message)";
}

class NetworkException implements Exception {
  final String message;

  const NetworkException([this.message = "No Network Connection"]);

  @override
  String toString() => "NetworkException(message: $message)";
}

class AuthException implements Exception {
  final String message;
  final String? code;

  const AuthException(this.message, {this.code});

  @override
  String toString() => "AuthException(message: $message, code: $code)";
}

class ValidationException implements Exception {
  final String message;

  const ValidationException(this.message);

  @override
  String toString() => "ValidationException(message: $message)";
}
