import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/routes/app_router.dart';
import 'package:medi_connect/core/routes/route_guards.dart' show RouteGuards;
import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/features/admin/consultation_management/presentation/pages/patient_registration_record_detail_page.dart';
import 'package:medi_connect/features/admin/customer_care/presentation/pages/patient_registration_page.dart';
import 'package:medi_connect/features/admin/customer_care/presentation/pages/patient_search_page.dart';
import 'package:medi_connect/features/admin/customer_care/presentation/pages/qr_registration_page.dart';
import 'package:medi_connect/features/admin/home/admin_home_page.dart';
import 'package:medi_connect/features/admin/staff_management/data/models/department_model.dart';
import 'package:medi_connect/features/admin/staff_management/presentation/pages/department_detail.dart';
import 'package:medi_connect/features/admin/staff_management/presentation/pages/department_list_page.dart';
import 'package:medi_connect/features/admin/staff_management/presentation/pages/doctor_detail_screen.dart';
import 'package:medi_connect/features/admin/staff_management/presentation/pages/doctor_staff_create_page.dart';
import 'package:medi_connect/features/admin/staff_management/presentation/pages/doctor_staff_detail_page.dart';
import 'package:medi_connect/features/admin/staff_management/presentation/pages/doctor_staff_edit_page.dart';
import 'package:medi_connect/features/admin/staff_management/presentation/pages/employee_detail_screen.dart';
import 'package:medi_connect/features/admin/staff_management/presentation/pages/section_detail.dart';
import 'package:medi_connect/features/admin/staff_management/presentation/pages/section_list_page.dart';
import 'package:medi_connect/features/authentication/data/models/user_model.dart';
import 'package:medi_connect/features/authentication/onboarding/onboarding_page.dart';
import 'package:medi_connect/features/authentication/presentation/pages/admin_login_page.dart';
import 'package:medi_connect/features/authentication/presentation/pages/admin_signup_page.dart';
import 'package:medi_connect/features/common/dashboard/presentation/pages/admin/admin_add_slot_page.dart';
import 'package:medi_connect/features/common/dashboard/presentation/pages/admin/admin_audit_logs_page.dart';
import 'package:medi_connect/features/common/dashboard/presentation/pages/admin/admin_doctors_page.dart';
import 'package:medi_connect/features/common/dashboard/presentation/pages/admin/admin_emergencies_page.dart';
import 'package:medi_connect/features/common/dashboard/presentation/pages/admin/admin_labs_page.dart';
import 'package:medi_connect/features/common/dashboard/presentation/pages/admin/admin_manage_slots_page.dart';
import 'package:medi_connect/features/common/dashboard/presentation/pages/admin/admin_master_data_page.dart';
import 'package:medi_connect/features/common/dashboard/presentation/pages/admin/admin_notifications_page.dart';
import 'package:medi_connect/features/common/dashboard/presentation/pages/admin/admin_pharmacy_page.dart';
import 'package:medi_connect/features/common/dashboard/presentation/pages/admin/admin_recent_activity_page.dart';
import 'package:medi_connect/features/common/dashboard/presentation/pages/admin/admin_settings_page.dart';
import 'package:medi_connect/features/common/dashboard/presentation/pages/admin/admin_slot_config_page.dart';
import 'package:medi_connect/features/common/dashboard/presentation/pages/admin/admin_staff_attendance_page.dart';
import 'package:medi_connect/features/common/dashboard/presentation/pages/admin/admin_staff_page.dart';
import 'package:medi_connect/features/common/dashboard/presentation/pages/staff/staff_dashboard_page.dart';
import 'package:medi_connect/features/common/splash/splash_page.dart';
import 'package:medi_connect/features/doctor/dashboard/presentation/pages/doctor_dashboard_page.dart';
import 'package:medi_connect/features/doctor/dashboard/presentation/pages/pending_mrd_page.dart';
import 'package:medi_connect/features/doctor/op_info/presentation/pages/op_info_page.dart';
import 'package:medi_connect/features/patient/dashboard/presentation/pages/patient_dashboard_page.dart';
import 'package:medi_connect/features/patient/profile/presentation/pages/patient_detail_screen.dart';
import 'package:medi_connect/features/patient/speciality/presentation/pages/speciality_list_page.dart';
import 'package:medi_connect/features/staff/patient/pages/staff_patient_registration.dart';

// Banners & Specialties Feature

// Unified Profile Pages

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
          builder: (context, state) => const AdminHomePage(),
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
          path: RouteNames.doctorOpInfo,
          builder: (context, state) =>
              OpInfoPage(initialDate: state.extra as DateTime?),
        ),
        GoRoute(
          path: RouteNames.doctorPendingMrd,
          builder: (context, state) => const PendingMrdPage(),
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
          path: '/staff/patientRegistration',
          builder: (context, state) => const StaffPatientRegistration(),
        ),
        GoRoute(
          path: RouteNames.profileCompletion,
          builder: (context, state) => const StaffPatientRegistration(),
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
          path: '/admin/slot-config',
          builder: (context, state) => const AdminSlotConfigPage(),
        ),
        GoRoute(
          path: '/admin/audit-logs',
          builder: (context, state) => const AdminAuditLogsPage(),
        ),
        GoRoute(
          path: '/admin/notifications',
          builder: (context, state) => const AdminNotificationsPage(),
        ),
        GoRoute(
          path: '/admin/master-data',
          builder: (context, state) => const AdminMasterDataPage(),
        ),

        GoRoute(
          path: "/sectionDetail",
          builder: (context, state) =>
              SectionDetail(section: state.extra as DepartmentModel),
        ),
        GoRoute(
          path: "/departmentDetail",
          builder: (context, state) =>
              DepartmentDetail(department: state.extra as DepartmentModel),
        ),
        GoRoute(
          path: '/admin/doctor-staff/detail',
          builder: (context, state) =>
              DoctorStaffDetailPage(user: state.extra as UserModel),
        ),
        GoRoute(
          path: '/admin/doctor-staff/manage-slots',
          builder: (context, state) =>
              AdminManageSlotsPage(user: state.extra as UserModel),
        ),
        GoRoute(
          path: '/admin/doctor-staff/add-slot',
          builder: (context, state) =>
              AdminAddSlotPage(user: state.extra as UserModel),
        ),
        GoRoute(
          path: '/admin/doctor-staff/edit',
          builder: (context, state) =>
              DoctorStaffEditPage(user: state.extra as UserModel),
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
        GoRoute(
          path: RouteNames.patientRegistration,
          builder: (context, state) => const PatientRegistrationPage(),
        ),
        GoRoute(
          path: RouteNames.patientSearch,
          builder: (context, state) => const PatientSearchPage(),
        ),
        GoRoute(
          path: RouteNames.qrRegistration,
          builder: (context, state) => const QrRegistrationPage(),
        ),
        GoRoute(
          path: RouteNames.patientRegistrationRecordDetail,
          builder: (context, state) => PatientRegistrationRecordDetailPage(
            record: state.extra as Map<String, dynamic>,
          ),
        ),
        GoRoute(
          path: RouteNames.adminSettings,
          builder: (context, state) =>
              const AdminSettingsPage(isStandalone: true),
        ),
        GoRoute(
          path: RouteNames.staffSettings,
          builder: (context, state) =>
              const AdminSettingsPage(isStandalone: true),
        ),
        GoRoute(
          path: RouteNames.specialities,
          builder: (context, state) =>
              SpecialityListPage(initialQuery: state.extra as String?),
        ),
        GoRoute(
          path: RouteNames.patientDetail,
          builder: (context, state) =>
              PatientDetailScreen(userId: state.extra as String),
        ),
        GoRoute(
          path: RouteNames.doctorDetail,
          builder: (context, state) =>
              DoctorDetailScreen(userId: state.extra as String),
        ),
        GoRoute(
          path: RouteNames.employeeDetail,
          builder: (context, state) =>
              EmployeeDetailScreen(userId: state.extra as String),
        ),
      ],
    );
  }
}
