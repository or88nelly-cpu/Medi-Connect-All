/// Local data-layer exceptions that will be caught and converted
/// to Failure objects in the repository implementations.
library;

class ServerException implements Exception {
  final String message;
  final String? code;

  ServerException(this.message, {this.code});

  @override
  String toString() => "ServerException(message: $message, code: $code)";
}

class CacheException implements Exception {
  final String message;

  CacheException(this.message);

  @override
  String toString() => "CacheException(message: $message)";
}

class NetworkException implements Exception {
  final String message;

  NetworkException([this.message = "No Network Connection"]);

  @override
  String toString() => "NetworkException(message: $message)";
}

class AuthException implements Exception {
  final String message;
  final String? code;

  AuthException(this.message, {this.code});

  @override
  String toString() => "AuthException(message: $message, code: $code)";
}

class ValidationException implements Exception {
  final String message;

  ValidationException(this.message);

  @override
  String toString() => "ValidationException(message: $message)";
}

class ApiException implements Exception {
  final String message;
  final String? code;

  ApiException(this.message, {this.code});

  @override
  String toString() => "ApiException(message: $message, code: $code)";
}

class UnknownException implements Exception {
  final String message;

  UnknownException([this.message = "An unknown exception occurred."]);

  @override
  String toString() => "UnknownException(message: $message)";
}
