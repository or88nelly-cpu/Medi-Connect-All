import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/router/route_names.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/dashboard_tab_cubit.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/navigation/doctor_bottom_nav_bar.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/role_drawers.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/utils/profile_image_helper.dart';

class DoctorDashboardPage extends StatefulWidget {
  const DoctorDashboardPage({super.key});

  @override
  State<DoctorDashboardPage> createState() => _DoctorDashboardPageState();
}

class _DoctorDashboardPageState extends State<DoctorDashboardPage> {
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
              customAppbar: currentIndex == 0
                  ? AppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      title: Text(
                        AppStrings.doctorDashboardTitle,
                        style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold),
                      ),
                    )
                  : null,
              drawer: const DoctorDrawer(),
              body: IndexedStack(
                index: currentIndex,
                children: [
                  const _DoctorHomeTab(),
                  const _DoctorScheduleTab(),
                  const _DoctorPatientsTab(),
                  const _DoctorConsultsTab(),
                  const _DoctorProfileTab(),
                ],
              ),
              bottomNavigationBar: DoctorBottomNavBar(
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
// Doctor Home Tab
// ─────────────────────────────────────────────────────────────────────────────
class _DoctorHomeTab extends StatelessWidget {
  const _DoctorHomeTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DoctorWelcomeBanner(),
          SizedBox(height: 20.h),
          Text(
            "Quick Stats",
            style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildStatCard("Total Appointments", "18", AppColors.primary),
              SizedBox(width: 12.w),
              _buildStatCard("Completed Consults", "14", AppColors.success),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            "Today's Highlight Consultations",
            style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),
          _DoctorConsultationsCard(),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.bodySmall),
            SizedBox(height: 4.h),
            Text(
              value,
              style: AppTextStyles.headingMedium.copyWith(
                color: color,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorWelcomeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String name = 'Doctor';
        String? profileImage;
        String? specialty = 'General Medicine';

        if (state is Authenticated) {
          final user = state.user;
          name = user.name ?? "${user.firstName ?? ''} ${user.lastName ?? ''}".trim();
          profileImage = user.profileImage;
          specialty = user.specialization ?? 'General Practitioner';
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: AppColors.doctorGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withOpacity(0.25),
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
                      style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
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
                    SizedBox(height: 4.h),
                    Text(
                      specialty!,
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
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
                    'doctor',
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

class _DoctorConsultationsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> todayAppointments = [
      {'name': 'Mr. Michael Miller', 'time': '10:30 AM', 'type': 'Physical Visit'},
      {'name': 'Mrs. Sarah Connor', 'time': '11:00 AM', 'type': 'Video consultation'},
      {'name': 'Mr. Bruce Wayne', 'time': '01:30 PM', 'type': 'Physical Visit'},
    ];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: todayAppointments.length,
        separatorBuilder: (context, idx) => const Divider(color: AppColors.border, height: 1),
        itemBuilder: (context, idx) {
          final apt = todayAppointments[idx];
          return ListTile(
            contentPadding: EdgeInsets.all(16.r),
            leading: CircleAvatar(
              backgroundColor: AppColors.secondary.withOpacity(0.1),
              child: Icon(Icons.person, color: AppColors.secondary),
            ),
            title: Text(
              apt['name']!,
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            subtitle: Text("Type: ${apt['type']!}"),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                apt['time']!,
                style: TextStyle(color: AppColors.secondary, fontSize: 10.sp, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Doctor Schedule Tab
// ─────────────────────────────────────────────────────────────────────────────
class _DoctorScheduleTab extends StatelessWidget {
  const _DoctorScheduleTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Today's Schedule", style: AppTextStyles.headingMedium.copyWith(fontSize: 22.sp)),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView(
              children: [
                _buildScheduleRow("09:00 AM", "Staff Briefing", "General Conference", true),
                _buildScheduleRow("10:00 AM", "Michael Miller", "Physical OPD - Room 3", false),
                _buildScheduleRow("11:00 AM", "Sarah Connor", "Video consultation - App Room", false),
                _buildScheduleRow("12:00 PM", "Lunch Break", "Cafeteria", true),
                _buildScheduleRow("01:30 PM", "Bruce Wayne", "Physical OPD - Room 3", false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleRow(String time, String title, String detail, bool isBreak) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isBreak ? AppColors.divider : AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Text(time, style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14.sp)),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                Text(detail, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Doctor Patients Tab
// ─────────────────────────────────────────────────────────────────────────────
class _DoctorPatientsTab extends StatelessWidget {
  const _DoctorPatientsTab();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> patients = [
      {'name': 'Michael Miller', 'age': '54', 'gender': 'Male', 'issue': 'Hypertension'},
      {'name': 'Sarah Connor', 'age': '38', 'gender': 'Female', 'issue': 'Cardiac Arrhythmia'},
      {'name': 'Bruce Wayne', 'age': '42', 'gender': 'Male', 'issue': 'Ankle Sprain'},
    ];

    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("My Patients", style: AppTextStyles.headingMedium.copyWith(fontSize: 22.sp)),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, idx) {
                final p = patients[idx];
                return Card(
                  margin: EdgeInsets.only(bottom: 12.h),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.r),
                    title: Text(p['name']!, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                    subtitle: Text("Age: ${p['age']!} | Gender: ${p['gender']!} \nIssue: ${p['issue']!}"),
                    trailing: const Icon(Icons.chevron_right),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Doctor Consults Tab
// ─────────────────────────────────────────────────────────────────────────────
class _DoctorConsultsTab extends StatelessWidget {
  const _DoctorConsultsTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Video Consultations", style: AppTextStyles.headingMedium.copyWith(fontSize: 22.sp)),
          SizedBox(height: 16.h),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r), side: const BorderSide(color: AppColors.border)),
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                children: [
                  Icon(Icons.video_camera_front_outlined, size: 60.r, color: AppColors.secondary),
                  SizedBox(height: 12.h),
                  Text("Next Virtual Session", style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4.h),
                  Text("Patient: Sarah Connor", style: AppTextStyles.bodyMedium),
                  Text("Time: Today, 11:00 AM", style: AppTextStyles.bodySmall),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Launching video consultation room...")),
                        );
                      },
                      icon: const Icon(Icons.video_call, color: Colors.white),
                      label: const Text("Launch Consult", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Doctor Profile Tab
// ─────────────────────────────────────────────────────────────────────────────
class _DoctorProfileTab extends StatelessWidget {
  const _DoctorProfileTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String name = "Doctor";
        String email = "doctor@mediconnect.com";
        String? phone = "+91 98765 43210";
        String? specialty = "General Practitioner";
        String? profileImage;

        if (state is Authenticated) {
          final user = state.user;
          name = user.name ?? "${user.firstName ?? ''} ${user.lastName ?? ''}".trim();
          email = user.email;
          phone = user.phoneNumber;
          specialty = user.specialization;
          profileImage = user.profileImage;
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.r),
          child: Column(
            children: [
              Container(
                width: 100.r,
                height: 100.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.secondary, width: 3),
                ),
                child: CustomImageView(
                  imagePath: ProfileImageHelper.resolveImagePath(
                    profileImage,
                    'doctor',
                    state is Authenticated ? state.user.gender : null,
                  ),
                  borderRadius: 50.r,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                name,
                style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                email,
                style: AppTextStyles.bodyMedium,
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  specialty ?? 'General Medicine',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildInfoTile(Icons.phone_outlined, "Phone", phone ?? "Not Set"),
                    const Divider(color: AppColors.border, height: 1),
                    _buildInfoTile(Icons.badge_outlined, "Registration Number", "REG-DOC-2819"),
                    const Divider(color: AppColors.border, height: 1),
                    _buildInfoTile(Icons.work_outline, "Experience", "8 Years"),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutRequested());
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text("Sign Out", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    padding: EdgeInsets.all(16.r),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.secondary),
      title: Text(
        title,
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
      trailing: Text(
        value,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
