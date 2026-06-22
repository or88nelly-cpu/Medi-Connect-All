/// Router redirection and guard logic.
/// Handles protected routes and role-based access control using the Supabase session.
library;

import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/services/app_logger.dart';
import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/core/services/secure_storage_service.dart';

class RouteGuards {
  final SupabaseService _supabaseService;
  final SecureStorageService _secureStorageService;

  RouteGuards(this._supabaseService, this._secureStorageService);

  /// Global redirect handler to enforce authentication and roles.
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) async {
    final isAuthenticated = _supabaseService.isAuthenticated;
    final currentPath = state.matchedLocation;

    final isAuthRoute =
        currentPath == RouteNames.login ||
        currentPath == RouteNames.register ||
        currentPath == RouteNames.onboarding ||
        currentPath == RouteNames.forgotPassword ||
        currentPath == RouteNames.resetPassword ||
        currentPath == RouteNames.otpVerification ||
        currentPath == RouteNames.splash;

    if (!isAuthenticated) {
      // User is not authenticated. Redirect to login if trying to access a protected route.
      if (!isAuthRoute) {
        AppLogger.navigation(
          "Unauthenticated access to $currentPath. Redirecting to Login.",
        );
        return RouteNames.login;
      }
      return null;
    }

    // User is authenticated.
    // Fetch profile completion status and role from secure storage
    final completionStatusStr = await _secureStorageService.read(
      'profile_completion_status',
    );
    final cachedRole = await _secureStorageService.read('user_role');

    final isProfileComplete = completionStatusStr == 'true';
    final userRole =
        cachedRole ??
        _supabaseService.currentUser?.userMetadata?['role'] as String? ??
        'patient';

    // If profile is incomplete, redirect to profile completion flow
    if (!isProfileComplete) {
      if (currentPath != RouteNames.profileCompletion) {
        AppLogger.navigation(
          "Profile incomplete. Redirecting from $currentPath to Profile Onboarding.",
        );
        return RouteNames.profileCompletion;
      }
      return null;
    }

    // If profile is complete but user is trying to access auth route or profile completion, redirect to dashboard
    if (isAuthRoute || currentPath == RouteNames.profileCompletion) {
      AppLogger.navigation(
        "Authenticated user on auth/completion route. Redirecting to dashboard.",
      );
      return _getDashboardRouteForRole(userRole);
    }

    // Check role boundaries
    if (currentPath.startsWith('/patient') && userRole != 'patient') {
      AppLogger.warning(
        "Role mismatch. User with role '$userRole' tried to access patient path. Redirecting.",
      );
      return _getDashboardRouteForRole(userRole);
    }
    if (currentPath.startsWith('/doctor') && userRole != 'doctor') {
      AppLogger.warning(
        "Role mismatch. User with role '$userRole' tried to access doctor path. Redirecting.",
      );
      return _getDashboardRouteForRole(userRole);
    }
    if (currentPath.startsWith('/staff') && userRole != 'staff') {
      AppLogger.warning(
        "Role mismatch. User with role '$userRole' tried to access staff path. Redirecting.",
      );
      return _getDashboardRouteForRole(userRole);
    }
    if (currentPath.startsWith('/admin') && userRole != 'admin') {
      AppLogger.warning(
        "Role mismatch. User with role '$userRole' tried to access admin path. Redirecting.",
      );
      return _getDashboardRouteForRole(userRole);
    }

    // Route is safe
    return null;
  }

  String _getDashboardRouteForRole(String role) {
    switch (role) {
      case 'doctor':
        return RouteNames.doctorDashboard;
      case 'staff':
        return RouteNames.staffDashboard;
      case 'admin':
        return RouteNames.adminDashboard;
      case 'patient':
      default:
        return RouteNames.patientDashboard;
    }
  }
}
