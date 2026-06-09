/// Configuration and builder for GoRouter.
/// Integrates custom guards and observers to enable secure role-based navigation.
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'route_guards.dart';
import 'navigation_observer.dart';

class AppRouter {
  /// Builds a customized GoRouter instance with role guards and navigation logging.
  static GoRouter build({
    required RouteGuards guards,
    required List<RouteBase> routes,
    String initialLocation = '/',
    Listenable? refreshListenable,
  }) {
    return GoRouter(
      initialLocation: initialLocation,
      refreshListenable: refreshListenable,
      redirect: guards.redirect,
      routes: routes,
      observers: [AppNavigationObserver()],
    );
  }

  AppRouter._();
}
