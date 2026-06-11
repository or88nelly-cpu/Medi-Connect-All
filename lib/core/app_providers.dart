import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/core/themes/theme_cubit.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/dashboard_analytics_bloc.dart';
import 'package:medi_connect/features/department/presentation/bloc/department_bloc.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/core/departments_config.dart';
import 'package:medi_connect/features/patient/presentation/bloc/patient_bloc.dart';

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
      ...getAllDepartmentsProviders(sl),
    ];
  }
}


