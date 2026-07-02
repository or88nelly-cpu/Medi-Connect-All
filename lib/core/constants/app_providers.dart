import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/core/theme/theme_cubit.dart';
import 'package:medi_connect/core/constants/departments_config.dart';
import 'package:medi_connect/modules/management/patient_management/presentation/bloc/patient_bloc.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/department_bloc.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_appointments_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_attendance_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_billing_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_emergencies_bloc.dart'
    show AdminEmergenciesBloc;
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_labs_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_pharmacy_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_recent_activity_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_settings_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/dashboard_analytics_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/doctor/doctor_appointments_bloc.dart';
import 'package:medi_connect/modules/patient/dashboard/presentation/bloc/banner_bloc.dart';
import 'package:medi_connect/modules/patient/speciality/presentation/bloc/speciality_bloc.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/user_details_bloc.dart';

class AppProviders {
  static List<BlocProvider> getProviders() {
    final sl = GetIt.instance;
    return [
      BlocProvider<ThemeCubit>(create: (_) => sl<ThemeCubit>()),
      BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
      BlocProvider<DashboardAnalyticsBloc>(
        create: (_) => sl<DashboardAnalyticsBloc>(),
      ),
      BlocProvider<DepartmentBloc>(create: (_) => sl<DepartmentBloc>()),
      BlocProvider<DoctorStaffBloc>(create: (_) => sl<DoctorStaffBloc>()),
      BlocProvider<PatientBloc>(create: (_) => sl<PatientBloc>()),
      BlocProvider<AdminPharmacyBloc>(create: (_) => sl<AdminPharmacyBloc>()),
      BlocProvider<AdminLabsBloc>(create: (_) => sl<AdminLabsBloc>()),
      BlocProvider<AdminAttendanceBloc>(
        create: (_) => sl<AdminAttendanceBloc>(),
      ),
      BlocProvider<AdminEmergenciesBloc>(
        create: (_) => sl<AdminEmergenciesBloc>(),
      ),
      BlocProvider<AdminBillingBloc>(create: (_) => sl<AdminBillingBloc>()),
      BlocProvider<AdminSettingsBloc>(create: (_) => sl<AdminSettingsBloc>()),
      BlocProvider<AdminRecentActivityBloc>(
        create: (_) => sl<AdminRecentActivityBloc>(),
      ),
      BlocProvider<AdminAppointmentsBloc>(
        create: (_) => sl<AdminAppointmentsBloc>(),
      ),
      BlocProvider<DoctorAppointmentsBloc>(
        create: (_) => sl<DoctorAppointmentsBloc>(),
      ),
      BlocProvider<BannerBloc>(
        create: (_) => sl<BannerBloc>(),
      ),
      BlocProvider<SpecialityBloc>(
        create: (_) => sl<SpecialityBloc>(),
      ),
      BlocProvider<UserDetailsBloc>(
        create: (_) => sl<UserDetailsBloc>(),
      ),
      ...getAllDepartmentsProviders(sl),
    ];
  }
}
