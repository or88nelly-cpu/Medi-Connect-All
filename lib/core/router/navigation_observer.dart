/// Navigation observer that logs routing transitions.
/// Integrates directly with AppLogger to capture navigation history.
import 'package:flutter/widgets.dart';
import 'package:medi_connect/core/common_models/logger/app_logger.dart';

class AppNavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    AppLogger.navigation(
      "PUSHED: ${route.settings.name} (${route.settings.arguments})",
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    AppLogger.navigation("POPPED: ${route.settings.name}");
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      AppLogger.navigation("REPLACED: ${newRoute.settings.name}");
    }
  }
}
