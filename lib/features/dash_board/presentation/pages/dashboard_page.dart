import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/router/route_names.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/dashboard_analytics_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/dashboard_tab_cubit.dart';
import 'package:medi_connect/features/dash_board/presentation/pages/dashboard_home_admin.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/admin_dashboard/admin_appbar.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/admin_drawer.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/navigation/admin_bottom_nav_bar.dart';
import 'package:medi_connect/features/department/presentation/bloc/department_bloc.dart';

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
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            context.go(RouteNames.login);
          }
        },
        child: BlocBuilder<DashboardTabCubit, int>(
          builder: (context, currentIndex) {
            return CustomScaffold(
              appBarNeeded: true,
              customAppbar: AdminAppbar(isDashoard: currentIndex == 0),
              drawer: AdminDrawer(),
              body: _getPage(currentIndex),
              bottomNavigationBar: AdminBottomNavBar(
                currentIndex: currentIndex,
                onTap: (i) => context.read<DashboardTabCubit>().setTab(i),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const DashboardHomeAdmin();
      default:
        return Container();
    }
  }
}
