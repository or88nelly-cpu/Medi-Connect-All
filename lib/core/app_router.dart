import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/core/router/app_router.dart';
import 'package:medi_connect/core/router/route_guards.dart';
import 'package:medi_connect/core/router/route_names.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/features/auth/presentation/pages/admin_login_page.dart';
import 'package:medi_connect/features/auth/presentation/pages/admin_signup_page.dart';
import 'package:medi_connect/features/auth/presentation/pages/splash_page.dart';
import 'package:medi_connect/features/dash_board/presentation/pages/dashboard_page.dart';
import 'package:medi_connect/features/dash_board/presentation/pages/patient_dashboard_page.dart';
import 'package:medi_connect/features/dash_board/presentation/pages/doctor_dashboard_page.dart';
import 'package:medi_connect/features/dash_board/presentation/pages/staff_dashboard_page.dart';
import 'package:medi_connect/features/dash_board/presentation/pages/admin_pharmacy_page.dart';
import 'package:medi_connect/features/dash_board/presentation/pages/admin_labs_page.dart';
import 'package:medi_connect/features/dash_board/presentation/pages/admin_staff_attendance_page.dart';
import 'package:medi_connect/features/dash_board/presentation/pages/admin_recent_activity_page.dart';
import 'package:medi_connect/features/dash_board/presentation/pages/admin_emergencies_page.dart';
import 'package:medi_connect/features/dash_board/presentation/pages/admin_doctors_page.dart';
import 'package:medi_connect/features/dash_board/presentation/pages/admin_staff_page.dart';
import 'package:medi_connect/features/department/data/models/department_model.dart';
import 'package:medi_connect/features/department/presentation/pages/department_detail.dart';
import 'package:medi_connect/features/department/presentation/pages/department_list_page.dart';
import 'package:medi_connect/features/department/presentation/pages/section_detail.dart';
import 'package:medi_connect/features/department/presentation/pages/section_list_page.dart';
import 'package:medi_connect/features/department/presentation/pages/doctor_staff_detail_page.dart';
import 'package:medi_connect/features/department/presentation/pages/doctor_staff_edit_page.dart';
import 'package:medi_connect/features/department/presentation/pages/doctor_staff_create_page.dart';
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
        GoRoute(
          path: "/departments",
          builder: (context, state) => const DepartmentListPage(),
        ),
        GoRoute(
          path: "/sections",
          builder: (context, state) => const SectionListPage(),
        ),
        GoRoute(
          path: '/admin/dashboard',
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: '/patient/dashboard',
          builder: (context, state) => const PatientDashboardPage(),
        ),
        GoRoute(
          path: '/doctor/dashboard',
          builder: (context, state) => const DoctorDashboardPage(),
        ),
        GoRoute(
          path: '/staff/dashboard',
          builder: (context, state) => const StaffDashboardPage(),
        ),
        GoRoute(
          path: '/admin/doctors',
          builder: (context, state) => const AdminDoctorsPage(),
        ),
        GoRoute(
          path: '/admin/staff',
          builder: (context, state) => const AdminStaffPage(),
        ),
        GoRoute(
          path: '/admin/pharmacy',
          builder: (context, state) => const AdminPharmacyPage(),
        ),
        GoRoute(
          path: '/admin/labs',
          builder: (context, state) => const AdminLabsPage(),
        ),
        GoRoute(
          path: '/admin/staff-attendance',
          builder: (context, state) => const AdminStaffAttendancePage(),
        ),
        GoRoute(
          path: '/admin/recent-activity',
          builder: (context, state) => const AdminRecentActivityPage(),
        ),
        GoRoute(
          path: '/admin/emergencies',
          builder: (context, state) => const AdminEmergenciesPage(),
        ),
        GoRoute(
          path: "/sectionDetail",
          builder: (context, state) => SectionDetail(
            section: state.extra as DepartmentModel,
          ),
        ),
        GoRoute(
          path: "/departmentDetail",
          builder: (context, state) =>
              DepartmentDetail(department: state.extra as DepartmentModel),
        ),
        GoRoute(
          path: '/admin/doctor-staff/detail',
          builder: (context, state) => DoctorStaffDetailPage(
            user: state.extra as UserModel,
          ),
        ),
        GoRoute(
          path: '/admin/doctor-staff/edit',
          builder: (context, state) => DoctorStaffEditPage(
            user: state.extra as UserModel,
          ),
        ),
        GoRoute(
          path: '/admin/doctor-staff/create',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return DoctorStaffCreatePage(
              role: extra['role'] as String,
              departmentName: extra['department'] as String,
            );
          },
        ),
      ],
    );
  }
}
