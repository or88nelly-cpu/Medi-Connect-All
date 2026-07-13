import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:medi_connect/core/errors/exceptions.dart';
import 'package:medi_connect/core/services/app_logger.dart';

/// Centralized API Error Parsing
class ApiErrorHandler {
  static Exception handleError(dynamic error) {
    AppLogger.error('API Error: $error', error: error);

    if (error is AuthException) {
      return UnauthorizedException(error.message);
    }

    if (error is PostgrestException) {
      final code = error.code;
      final message = error.message;

      // Map Supabase specific HTTP/PostgreSQL codes
      if (code == '23505') {
        return ServerException('Conflict: Data already exists', 409);
      } else if (code == 'PGRST116') {
        return ServerException('Not Found: Data does not exist', 404);
      } else if (code == 'PGRST301') {
        return UnauthorizedException('Unauthorized access or session expired');
      }

      return ServerException(message, int.tryParse(code ?? '500'));
    }

    if (error is SocketException) {
      return NetworkException('Failed to connect to the network');
    }

    if (error is FormatException) {
      return ParsingException('Invalid response format');
    }

    if (error.toString().contains('Timeout')) {
      return TimeoutException('Request timed out. Please try again.');
    }

    return ServerException('An unexpected error occurred. Please try again.');
  }
}
