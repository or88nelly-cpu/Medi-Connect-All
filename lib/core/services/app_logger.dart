/// Centralized logging utility for the Healthcare Platform.
/// Handles API, Bloc, Navigation, and Error logging using the `logger` package.
library;

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    filter: kReleaseMode
        ? ProductionFilter()
        : DevelopmentFilter(), // Suppress verbose logs in release
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );

  /// Log informative messages (e.g. initialization steps, configuration changes).
  static void info(String message) {
    _logger.i(message);
  }

  /// Log debug messages (e.g. local variable states, lifecycle updates).
  static void debug(String message) {
    _logger.d(message);
  }

  /// Log warning messages (e.g. unexpected responses, retries).
  static void warning(String message) {
    _logger.w(message);
  }

  /// Log error messages with stack traces (e.g. exceptions, crashes).
  static void error(String message, {dynamic error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log critical system-level failures.
  static void critical(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _logger.f(
      message,
      error: error,
      stackTrace: stackTrace,
    ); // 'f' for fatal/critical
  }

  /// Specialized API request/response logging.
  static void api(String message) {
    _logger.i("[API] $message");
  }

  /// Specialized Bloc transition and event logging.
  static void bloc(String message) {
    _logger.d("[Bloc] $message");
  }

  /// Specialized Navigation logs.
  static void navigation(String message) {
    _logger.i("[Navigation] $message");
  }
}
