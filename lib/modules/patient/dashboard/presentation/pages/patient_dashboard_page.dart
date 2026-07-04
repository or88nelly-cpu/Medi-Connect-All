import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/core/widgets/custom_scaffold.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/common/dashboard_tab_cubit.dart';
import 'package:medi_connect/modules/patient/dashboard/presentation/widgets/patient_appbar.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/navigation/patient_bottom_nav_bar.dart';
import 'package:medi_connect/modules/patient/dashboard/presentation/widgets/patient_dashboard/patient_home_tab.dart';
import 'package:medi_connect/modules/patient/dashboard/presentation/widgets/patient_dashboard/patient_premium_tab.dart';
import 'package:medi_connect/modules/patient/dashboard/presentation/widgets/patient_dashboard/patient_profile_tab.dart';
import 'package:medi_connect/modules/patient/dashboard/presentation/widgets/patient_dashboard/patient_records_tab.dart';

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
              customAppbar: PatientAppBar(),
              body: getBody(currentIndex),
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

  Widget getBody(int index) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: IndexedStack(
        index: index,
        children: const [
          PatientHomeTab(),
          PatientRecordsTab(),
          PatientProfileTab(),
          PatientPremiumTab(),
        ],
      ),
    );
  }
}
