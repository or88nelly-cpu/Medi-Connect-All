import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_drawer.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/department_bloc.dart';
import 'package:medi_connect/modules/admin/home/widgets/dashboard_header.dart';
import 'package:medi_connect/modules/admin/home/widgets/extra_card.dart';

import 'package:medi_connect/modules/admin/home/widgets/department_list_home.dart'
    show DepartmentListHome;

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<DepartmentBloc>(context).add(const LoadDepartments());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.go(RouteNames.login);
        }
      },
      builder: (context, state) {
        final user = state is Authenticated ? state.user : null;
        return CustomScaffold(
          drawer: AdminDrawer(),
          appBarNeeded: false,
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 66.w,
              vertical: 30.h,
            ).copyWith(left: 66.w - 58.r),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                DashboardHeader(user: user),
                SizedBox(height: 12.r),
                DepartmentListHome(),
                SizedBox(height: 12.r),
                ExtraCard(),
              ],
            ),
          ),
        );
      },
    );
  }
}
