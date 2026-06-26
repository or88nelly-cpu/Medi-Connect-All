import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/dashboard_analytics_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/common/dashboard_tab_cubit.dart';
import 'package:medi_connect/shared/dashboard/presentation/pages/admin/dashboard_home_admin.dart';
import 'package:medi_connect/shared/dashboard/presentation/pages/admin/admin_appointments_page.dart';
import 'package:medi_connect/shared/dashboard/presentation/pages/admin/admin_patients_page.dart';
import 'package:medi_connect/shared/dashboard/presentation/pages/admin/admin_billing_page.dart';
import 'package:medi_connect/shared/dashboard/presentation/pages/admin/admin_settings_page.dart';
import 'package:medi_connect/shared/dashboard/presentation/pages/admin/admin_profile_page.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_dashboard/admin_appbar.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_drawer.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/navigation/admin_bottom_nav_bar.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/department_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_appointments_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_billing_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/appointments/create_appointment_wizard_dialog.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCheckRequested());
    context.read<DashboardAnalyticsBloc>().add(LoadDashboardStats());
    context.read<DepartmentBloc>().add(const LoadDepartments());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardTabCubit(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is Unauthenticated) {
                context.go(RouteNames.login);
              }
            },
          ),
          BlocListener<AdminAppointmentsBloc, AdminAppointmentsState>(
            listener: (context, state) {
              if (state is AdminAppointmentsLoaded) {
                context.read<DashboardAnalyticsBloc>().add(
                  LoadDashboardStats(),
                );
              }
            },
          ),
          BlocListener<AdminBillingBloc, AdminBillingState>(
            listener: (context, state) {
              if (state is AdminBillingLoaded ||
                  state is AdminBillingInvoiceRecorded) {
                context.read<DashboardAnalyticsBloc>().add(
                  LoadDashboardStats(),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<DashboardTabCubit, int>(
          builder: (context, currentIndex) {
            return CustomScaffold(
              appBarNeeded: true,
              customAppbar: AdminAppbar(isDashoard: currentIndex == 0),
              drawer: AdminDrawer(),
              body: IndexedStack(
                index: currentIndex,
                children: [
                  const DashboardHomeAdmin(),
                  const AdminAppointmentsPage(),
                  const AdminPatientsPage(),
                  const AdminBillingPage(),
                  const AdminSettingsPage(),
                  const AdminProfilePage(),
                ],
              ),
              bottomNavigationBar: AdminBottomNavBar(
                currentIndex: currentIndex,
                onTap: (i) {
                  context.read<DashboardTabCubit>().setTab(i);
                  if (i == 0) {
                    context.read<DashboardAnalyticsBloc>().add(
                      LoadDashboardStats(),
                    );
                  }
                },
              ),
              floatingActionButton: currentIndex == 1
                  ? FloatingActionButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (ctx) =>
                              const CreateAppointmentWizardBottomSheet(),
                        );
                      },
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      child: Container(
                        width: 56.r,
                        height: 56.r,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFF0F6FFF), Color(0xFF8B5CF6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    )
                  : null,
            );
          },
        ),
      ),
    );
  }
}
