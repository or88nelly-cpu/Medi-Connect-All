import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/router/route_names.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/dashboard_analytics_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/dashboard_tab_cubit.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/admin_drawer.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/analytics_section.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/management_grid.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/navigation/admin_bottom_nav_bar.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/operations_grid.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/welcome_banner.dart';

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
            final isHome = currentIndex == 0;

            return CustomScaffold(
              appBarNeeded: isHome,
              customAppbar: isHome
                  ? AppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      title: Text(
                        AppStrings.adminDashboardTitle,
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      actions: [
                        IconButton(
                          icon: Icon(Icons.refresh, size: 22.r),
                          onPressed: () {
                            context.read<DashboardAnalyticsBloc>().add(
                              LoadDashboardStats(),
                            );
                          },
                        ),
                      ],
                    )
                  : null,
              drawer: const AdminDrawer(),
              body: IndexedStack(
                index: currentIndex,
                children: [
                  // Tab 0: Home view
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const WelcomeBanner(),
                        SizedBox(height: 24.h),
                        const AnalyticsSection(),
                        SizedBox(height: 24.h),
                        Text(
                          AppStrings.managementConsole,
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        const ManagementGrid(),
                        SizedBox(height: 24.h),
                        Text(
                          AppStrings.systemOperations,
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        const OperationsGrid(),
                      ],
                    ),
                  ),
                  // Tab 1: Payments
                  Container(),
                  // Tab 2: Analytics
                  Container(),
                  //  const app_analytics.AnalyticsPage(),
                  // Tab 3: Post
                  Container(),
                  // Tab 4: Profile
                  Container(),
                ],
              ),
              bottomNavigationBar: AdminBottomNavBar(
                currentIndex: currentIndex,
                onTap: (index) =>
                    context.read<DashboardTabCubit>().setTab(index),
              ),
            );
          },
        ),
      ),
    );
  }
}
