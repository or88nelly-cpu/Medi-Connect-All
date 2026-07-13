import 'package:flutter/foundation.dart';
import 'package:medi_connect/core/services/app_logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Centralized global error handler for catching and logging unhandled exceptions.
class GlobalErrorHandler {
  static void init() {
    // Catch Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      AppLogger.critical(
        'Caught by FlutterError.onError',
        error: details.exception,
        stackTrace: details.stack,
      );
      Sentry.captureException(details.exception, stackTrace: details.stack);
    };

    // Catch asynchronous Dart errors
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      AppLogger.critical(
        'Caught by PlatformDispatcher.onError',
        error: error,
        stackTrace: stack,
      );
      Sentry.captureException(error, stackTrace: stack);
      return true; // Prevent default crash behavior
    };

    AppLogger.info('Global Error Handler Initialized');
  }
}
