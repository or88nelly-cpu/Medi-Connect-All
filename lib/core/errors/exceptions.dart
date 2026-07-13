library;

/// Custom Exceptions for MediConnect
/// Used in the Data/Repository layers to throw specific error types.

class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException(this.message, [this.statusCode]);

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

class NetworkException implements Exception {
  final String message;

  NetworkException([this.message = 'No internet connection']);

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  final String message;

  CacheException([this.message = 'Failed to load local data']);

  @override
  String toString() => 'CacheException: $message';
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException([this.message = 'User is not authorized']);

  @override
  String toString() => 'UnauthorizedException: $message';
}

class ParsingException implements Exception {
  final String message;

  ParsingException([this.message = 'Failed to parse response']);

  @override
  String toString() => 'ParsingException: $message';
}

class TimeoutException implements Exception {
  final String message;

  TimeoutException([this.message = 'Request timed out']);

  @override
  String toString() => 'TimeoutException: $message';
}
