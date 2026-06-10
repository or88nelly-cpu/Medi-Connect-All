import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/router/route_names.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/utils/profile_image_helper.dart';
import 'package:medi_connect/core/utils/constants/app_assets.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/dashboard_tab_cubit.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/navigation/patient_bottom_nav_bar.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/role_drawers.dart';
import 'package:medi_connect/features/department/domain/entities/department_entity.dart';
import 'package:medi_connect/features/department/presentation/bloc/department_bloc.dart';
import 'package:medi_connect/features/department/presentation/widgets/department_horizontal_list.dart';

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
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : null,
              drawer: const PatientDrawer(),
              body: IndexedStack(
                index: currentIndex,
                children: [
                  _PatientHomeTab(),
                  Container(), // Appointments placeholder
                  Container(), // Records placeholder
                  Container(), // Chat placeholder
                  Container(), // Profile placeholder
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

// ─────────────────────────────────────────────────────────────────────────────
// Patient Home Tab
// ─────────────────────────────────────────────────────────────────────────────
class _PatientHomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Welcome Banner ─────────────────────────────
          _PatientWelcomeBanner(),
          SizedBox(height: 24.h),

          // ── Quick Stats ─────────────────────────────────
          Text(
            AppStrings.patientQuickActions,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          _PatientQuickStats(),
          SizedBox(height: 24.h),

          // ── Upcoming Appointments ──────────────────────
          Text(
            AppStrings.upcomingAppointments,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          _UpcomingAppointmentsCard(),
          SizedBox(height: 24.h),

          // ── Departments ────────────────────────────────
          BlocBuilder<DepartmentBloc, DepartmentState>(
            builder: (context, state) {
              final List<DepartmentEntity> departments =
                  state is DepartmentsLoaded
                  ? state.departments
                  : state is DepartmentActionSuccess
                  ? state.updatedDepartments
                  : [];
              return DepartmentHorizontalList(
                departments: departments,
                title: AppStrings.departments,
                isAdmin: false,
              );
            },
          ),
          SizedBox(height: 80.h),
        ],
      ),
    );
  }
}

class _PatientWelcomeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String name = 'Patient';
        String? profileImage;
        String? gender;

        if (state is Authenticated) {
          final user = state.user;
          name =
              user.name ??
              (user.firstName != null
                  ? '${user.firstName} ${user.lastName ?? ''}'.trim()
                  : 'Patient');
          profileImage = user.profileImage;
          gender = user.gender;
        }

        if (profileImage == null && gender != null) {
          profileImage = gender == 'Male'
              ? AppAssets.maleAvatarPng
              : AppAssets.femaleAvatarPng;
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: AppColors.patientGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(38),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.welcomeUser,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      name,
                      style: AppTextStyles.headingMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        'Patient Portal',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Container(
                width: 64.r,
                height: 64.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white30, width: 2),
                ),
                child: CustomImageView(
                  imagePath: ProfileImageHelper.resolveImagePath(
                    profileImage,
                    'patient',
                    state is Authenticated ? state.user.gender : null,
                  ),
                  borderRadius: 32.r,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PatientQuickStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _QuickStatCard(
          icon: Icons.calendar_today,
          label: 'Appointments',
          value: '3',
          color: AppColors.primary,
        ),
        SizedBox(width: 12.w),
        _QuickStatCard(
          icon: Icons.folder_open,
          label: 'Records',
          value: '12',
          color: AppColors.secondary,
        ),
        SizedBox(width: 12.w),
        _QuickStatCard(
          icon: Icons.medical_services_outlined,
          label: 'Prescriptions',
          value: '5',
          color: AppColors.accent,
        ),
      ],
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _QuickStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: color.withAlpha(40)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24.r),
            SizedBox(height: 6.h),
            Text(
              value,
              style: AppTextStyles.titleLarge.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(fontSize: 9.sp),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingAppointmentsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _AppointmentRow(
            doctorName: 'Dr. Sarah Johnson',
            specialty: 'Cardiologist',
            time: 'Today, 10:30 AM',
            color: AppColors.primary,
          ),
          Divider(color: AppColors.border, height: 20.h),
          _AppointmentRow(
            doctorName: 'Dr. Michael Chen',
            specialty: 'Neurologist',
            time: 'Tomorrow, 2:00 PM',
            color: AppColors.secondary,
          ),
        ],
      ),
    );
  }
}

class _AppointmentRow extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String time;
  final Color color;

  const _AppointmentRow({
    required this.doctorName,
    required this.specialty,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            color: color.withAlpha(20),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person, color: color, size: 20.r),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctorName,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                specialty,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: color.withAlpha(15),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            time,
            style: AppTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 9.sp,
            ),
          ),
        ),
      ],
    );
  }
}
