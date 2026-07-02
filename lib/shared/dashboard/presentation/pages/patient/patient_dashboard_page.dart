import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/common/dashboard_tab_cubit.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/navigation/patient_bottom_nav_bar.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_home_tab.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_appointments_tab.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_records_tab.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_chat_tab.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_profile_tab.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/role_drawers.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/department_bloc.dart';

class PatientDashboardPage extends StatefulWidget {
  const PatientDashboardPage({super.key});

  @override
  State<PatientDashboardPage> createState() => _PatientDashboardPageState();
}

class _PatientDashboardPageState extends State<PatientDashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCheckRequested());
    context.read<DepartmentBloc>().add(const LoadDepartments());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardTabCubit(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) context.go(RouteNames.login);
        },
        child: BlocBuilder<DashboardTabCubit, int>(
          builder: (context, currentIndex) {
            return CustomScaffold(
              appBarNeeded: currentIndex == 0,
              customAppbar: currentIndex == 0
                  ? AppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      title: Text(
                        AppStrings.patientDashboardTitle,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : null,
              drawer: const PatientDrawer(),
              body: IndexedStack(
                index: currentIndex,
                children: const [
                  PatientHomeTab(),
                  PatientAppointmentsTab(),
                  PatientRecordsTab(),
                  PatientChatTab(),
                  PatientProfileTab(),
                ],
              ),
              bottomNavigationBar: PatientBottomNavBar(
                currentIndex: currentIndex,
                onTap: (i) => context.read<DashboardTabCubit>().setTab(i),
              ),
            );
          },
        ),
      ),
    );
  }
}
