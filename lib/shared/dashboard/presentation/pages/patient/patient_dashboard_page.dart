import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_assets.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/common/dashboard_tab_cubit.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/navigation/patient_bottom_nav_bar.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_home_tab.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_records_tab.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_profile_tab.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_premium_tab.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                      automaticallyImplyLeading: false,
                      toolbarHeight: 64.h,
                      title: Row(
                        children: [
                          // Brand Logo
                          Image.asset(
                            AppAssets.logoIconPng,
                            width: 32.r,
                            height: 32.r,
                          ),
                          SizedBox(width: 6.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'MediConnect',
                                style: TextStyle(
                                  color: const Color(0xFF0A3BB0),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                'Connecting Care. Empowering Health.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 7.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 12.w),

                          // Search Bar
                          Expanded(
                            child: Container(
                              height: 38.h,
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.terminalDarkCard
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white24
                                      : Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                    size: 16.r,
                                  ),
                                  SizedBox(width: 6.w),
                                  Expanded(
                                    child: TextField(
                                      readOnly: true,
                                      onTap: () =>
                                          context.push('/specialities'),
                                      decoration: InputDecoration(
                                        hintText:
                                            'Search doctors, specialities...',
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10.sp,
                                        ),
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),

                          // Notification Bell Icon with Badge
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                padding: EdgeInsets.all(6.r),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.terminalDarkCard
                                      : Colors.grey.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.notifications_none_rounded,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black87,
                                  size: 20.r,
                                ),
                              ),
                              Positioned(
                                top: -2,
                                right: -2,
                                child: Container(
                                  padding: EdgeInsets.all(4.r),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '3',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 7.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 10.w),

                          // Profile Avatar with Crown Badge
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, authState) {
                              String? profilePhoto;
                              String? gender;
                              if (authState is Authenticated) {
                                profilePhoto = authState.user.profilePhoto;
                                gender = authState.user.gender;
                              }
                              final avatarImage = profilePhoto != null
                                  ? NetworkImage(profilePhoto) as ImageProvider
                                  : AssetImage(
                                          gender == 'Male'
                                              ? AppAssets.maleAvatarPng
                                              : AppAssets.femaleAvatarPng,
                                        )
                                        as ImageProvider;

                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  CircleAvatar(
                                    radius: 18.r,
                                    backgroundImage: avatarImage,
                                  ),
                                  Positioned(
                                    bottom: -2,
                                    right: -2,
                                    child: Container(
                                      padding: EdgeInsets.all(2.r),
                                      decoration: const BoxDecoration(
                                        color: AppColors.secondary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.workspace_premium,
                                        color: Colors.white,
                                        size: 8.r,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  : null,
              drawer: const PatientDrawer(),
              body: IndexedStack(
                index: currentIndex,
                children: const [
                  PatientHomeTab(),
                  PatientRecordsTab(),
                  PatientProfileTab(),
                  PatientPremiumTab(),
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
