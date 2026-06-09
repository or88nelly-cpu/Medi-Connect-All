import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/core/router/app_router.dart';
import 'package:medi_connect/core/router/route_guards.dart';
import 'package:medi_connect/core/router/route_names.dart';
import 'package:medi_connect/features/auth/presentation/pages/admin_login_page.dart';
import 'package:medi_connect/features/auth/presentation/pages/admin_signup_page.dart';
import 'package:medi_connect/features/auth/presentation/pages/splash_page.dart';
import 'package:medi_connect/features/dash_board/presentation/pages/dashboard_page.dart';
import 'package:medi_connect/features/onboarding/presentation/pages/onboarding_page.dart';


class AppRouterConfig {
  static GoRouter buildRouter() {
    final sl = GetIt.instance;
    final guards = sl<RouteGuards>();

    return AppRouter.build(
      guards: guards,
      initialLocation: RouteNames.splash,
      routes: [
        GoRoute(
          path: RouteNames.splash,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: RouteNames.onboarding,
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(
          path: RouteNames.login,
          builder: (context, state) => const AdminLoginPage(),
        ),
        GoRoute(
          path: RouteNames.register,
          builder: (context, state) => const AdminSignUpPage(),
        ),
        // GoRoute(
        //   path: RouteNames.profileCompletion,
        //   builder: (context, state) => const ProfileCompletionPage(),
        // ),
        // GoRoute(
        //   path: RouteNames.otpVerification,
        //   builder: (context, state) =>
        //       OtpPage(email: state.extra as String? ?? ""),
        // ),
        // GoRoute(
        //   path: RouteNames.forgotPassword,
        //   builder: (context, state) => const ForgotPasswordPage(),
        // ),
        // GoRoute(
        //   path: RouteNames.resetPassword,
        //   builder: (context, state) => const ResetPasswordPage(),
        // ),
        GoRoute(
          path: '/admin/dashboard',
          builder: (context, state) => const DashboardPage(),
        ),
      ],
    );
  }
}
