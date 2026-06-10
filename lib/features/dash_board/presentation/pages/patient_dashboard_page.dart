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
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/core/common_widgets/dialogs/dialogs.dart';
import 'package:medi_connect/core/themes/theme_cubit.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/dashboard_tab_cubit.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/navigation/patient_bottom_nav_bar.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/role_drawers.dart';
import 'package:medi_connect/features/department/domain/entities/department_entity.dart';
import 'package:medi_connect/features/department/presentation/bloc/department_bloc.dart';
import 'package:medi_connect/features/department/presentation/widgets/department_horizontal_list.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

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
                  const _PatientAppointmentsTab(),
                  const _PatientRecordsTab(),
                  const _PatientChatTab(),
                  const _PatientProfileTab(),
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
                color: AppColors.primary.withOpacity(0.15),
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
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: color.withOpacity(0.15)),
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
            color: AppColors.primary.withOpacity(0.04),
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
            color: color.withOpacity(0.1),
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
            color: color.withOpacity(0.1),
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

// ─────────────────────────────────────────────────────────────────────────────
// Dynamic Book Doctor & Appointments Tab
// ─────────────────────────────────────────────────────────────────────────────
class _PatientAppointmentsTab extends StatefulWidget {
  const _PatientAppointmentsTab();

  @override
  State<_PatientAppointmentsTab> createState() =>
      _PatientAppointmentsTabState();
}

class _PatientAppointmentsTabState extends State<_PatientAppointmentsTab> {
  final List<Map<String, String>> _myAppointments = [
    {
      'doctor': 'Dr. Sarah Johnson',
      'specialty': 'Cardiologist',
      'time': 'June 12, 10:30 AM',
      'type': 'Cardiology Clinic',
    },
    {
      'doctor': 'Dr. Michael Chen',
      'specialty': 'Neurologist',
      'time': 'June 15, 02:00 PM',
      'type': 'Neurology Clinic',
    },
  ];

  Future<List<UserModel>> _fetchDoctorsList() async {
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select()
          .eq('role', 'doctor')
          .isFilter('deleted_at', null);

      return (response as List<dynamic>)
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Return empty list if query fails or table empty
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.appointments,
                style: AppTextStyles.headingMedium.copyWith(fontSize: 22.sp),
              ),
              ElevatedButton.icon(
                onPressed: () => _showBookDoctorDialog(context),
                icon: const Icon(Icons.search, color: Colors.white),
                label: const Text(
                  "Book Doctor",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            "My Scheduled Bookings",
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: ListView.builder(
              itemCount: _myAppointments.length,
              itemBuilder: (context, idx) {
                final apt = _myAppointments[idx];
                return Card(
                  margin: EdgeInsets.only(bottom: 12.h),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.r),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Icon(Icons.person, color: AppColors.primary),
                    ),
                    title: Text(
                      apt['doctor']!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text("${apt['specialty']!} | ${apt['type']!}"),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        apt['time']!,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showBookDoctorDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Find & Choose Doctor", style: AppTextStyles.titleLarge),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const Divider(color: AppColors.border),
              SizedBox(height: 12.h),
              Expanded(
                child: FutureBuilder<List<UserModel>>(
                  future: _fetchDoctorsList(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data!.isEmpty) {
                      // Return a fallback list of doctors if database empty
                      return _buildFallbackDoctorsList(ctx);
                    }

                    final doctors = snapshot.data!;
                    return ListView.builder(
                      itemCount: doctors.length,
                      itemBuilder: (context, idx) {
                        final doc = doctors[idx];
                        return _buildDoctorBookingTile(ctx, doc);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFallbackDoctorsList(BuildContext ctx) {
    // Fallback Mock doctors for demonstration
    final List<UserModel> fallbackDocs = [
      const UserModel(
        id: 'doc-1',
        email: 'sarah.j@mediconnect.com',
        name: 'Dr. Sarah Johnson',
        role: 'doctor',
        specialization: 'Cardiologist',
        department: 'Cardiology',
        consultationFee: 1200.0,
        experience: 12,
      ),
      const UserModel(
        id: 'doc-2',
        email: 'michael.c@mediconnect.com',
        name: 'Dr. Michael Chen',
        role: 'doctor',
        specialization: 'Neurologist',
        department: 'Neurology',
        consultationFee: 1500.0,
        experience: 9,
      ),
      const UserModel(
        id: 'doc-3',
        email: 'james.w@mediconnect.com',
        name: 'Dr. James Wilson',
        role: 'doctor',
        specialization: 'Pediatrician',
        department: 'Pediatrics',
        consultationFee: 1000.0,
        experience: 15,
      ),
    ];

    return ListView.builder(
      itemCount: fallbackDocs.length,
      itemBuilder: (context, idx) {
        final doc = fallbackDocs[idx];
        return _buildDoctorBookingTile(ctx, doc);
      },
    );
  }

  Widget _buildDoctorBookingTile(BuildContext ctx, UserModel doc) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.r),
        leading: CircleAvatar(
          backgroundColor: AppColors.secondary.withOpacity(0.1),
          child: Icon(
            Icons.local_hospital_outlined,
            color: AppColors.secondary,
          ),
        ),
        title: Text(
          doc.name ?? 'Dr. Specialist',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            Text(
              "${doc.specialization ?? 'General Medicine'} | Exp: ${doc.experience ?? 5} Yrs",
            ),
            Text("Fee: ₹ ${doc.consultationFee ?? 500}"),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.pop(ctx);
            _confirmBooking(doc);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
          child: const Text("Book", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  void _confirmBooking(UserModel doc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Confirm Appointment", style: AppTextStyles.titleLarge),
        content: Text(
          "Do you want to book an appointment with ${doc.name}?\nConsultation Fee: ₹ ${doc.consultationFee ?? 500}",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _myAppointments.insert(0, {
                  'doctor': doc.name ?? 'Dr. Specialist',
                  'specialty': doc.specialization ?? 'General Medicine',
                  'time': 'June 18, 09:30 AM',
                  'type': doc.department ?? 'General Clinic',
                });
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Appointment booked with ${doc.name} successfully.",
                  ),
                ),
              );
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Patient Records Tab
// ─────────────────────────────────────────────────────────────────────────────
class _PatientRecordsTab extends StatelessWidget {
  const _PatientRecordsTab();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> records = [
      {
        'title': 'CBC Blood Test Report',
        'date': 'June 08, 2026',
        'type': 'Lab Report',
        'doctor': 'Dr. Sarah Johnson',
      },
      {
        'title': 'ECG Assessment Report',
        'date': 'May 20, 2026',
        'type': 'Lab Report',
        'doctor': 'Dr. Sarah Johnson',
      },
      {
        'title': 'Neurological Symptoms Assessment',
        'date': 'May 12, 2026',
        'type': 'Prescription',
        'doctor': 'Dr. Michael Chen',
      },
    ];

    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.medicalRecords,
            style: AppTextStyles.headingMedium.copyWith(fontSize: 22.sp),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, idx) {
                final rec = records[idx];
                final isLab = rec['type'] == 'Lab Report';

                return Card(
                  margin: EdgeInsets.only(bottom: 12.h),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.r),
                    leading: Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: (isLab ? AppColors.secondary : AppColors.accent)
                            .withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isLab
                            ? Icons.science_outlined
                            : Icons.description_outlined,
                        color: isLab ? AppColors.secondary : AppColors.accent,
                      ),
                    ),
                    title: Text(
                      rec['title']!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      "Doctor: ${rec['doctor']!} \nDate: ${rec['date']!}",
                    ),
                    trailing: const Icon(Icons.download_outlined),
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
// Patient Chat Tab
// ─────────────────────────────────────────────────────────────────────────────
class _PatientChatTab extends StatelessWidget {
  const _PatientChatTab();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> chats = [
      {
        'doctor': 'Dr. Sarah Johnson',
        'specialty': 'Cardiologist',
        'lastMsg': 'Your ECG looks normal, please continue the medication.',
        'time': 'Yesterday',
      },
      {
        'doctor': 'Dr. Michael Chen',
        'specialty': 'Neurologist',
        'lastMsg': 'Let\'s schedule a checkup next week if headache persists.',
        'time': '3 days ago',
      },
    ];

    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.chat,
            style: AppTextStyles.headingMedium.copyWith(fontSize: 22.sp),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, idx) {
                final ch = chats[idx];
                return Card(
                  margin: EdgeInsets.only(bottom: 12.h),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.r),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Icon(Icons.person, color: AppColors.primary),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ch['doctor']!,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(ch['time']!, style: AppTextStyles.bodySmall),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 2.h),
                        Text(
                          ch['specialty']!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ch['lastMsg']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
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
// Patient Profile Tab
// ─────────────────────────────────────────────────────────────────────────────
class _PatientProfileTab extends StatelessWidget {
  const _PatientProfileTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String name = "Patient";
        String email = "patient@mediconnect.com";
        String? phone = "+91 98765 43210";
        String? profileImage;
        String bloodGroup = "O+";
        String allergies = "Penicillin";

        if (state is Authenticated) {
          final user = state.user;
          name =
              user.name ??
              "${user.firstName ?? ''} ${user.lastName ?? ''}".trim();
          email = user.email;
          phone = user.phoneNumber;
          profileImage = user.profileImage;
          bloodGroup = user.bloodGroup ?? 'O+';
          allergies = user.allergies ?? 'No Known Allergies';
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
                  border: Border.all(color: AppColors.primary, width: 3),
                ),
                child: CustomImageView(
                  imagePath: ProfileImageHelper.resolveImagePath(
                    profileImage,
                    'patient',
                    state is Authenticated ? state.user.gender : null,
                  ),
                  borderRadius: 50.r,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                name,
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(email, style: AppTextStyles.bodyMedium),
              SizedBox(height: 24.h),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildInfoTile(
                      Icons.phone_outlined,
                      "Phone",
                      phone ?? "Not Set",
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    _buildInfoTile(
                      Icons.bloodtype_outlined,
                      "Blood Group",
                      bloodGroup,
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    _buildInfoTile(
                      Icons.warning_amber_rounded,
                      "Allergies",
                      allergies,
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    BlocBuilder<ThemeCubit, ThemeMode>(
                      builder: (context, themeMode) {
                        final isDark = themeMode == ThemeMode.dark;
                        return SwitchListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                          ),
                          title: Text(
                            "Dark Mode",
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          value: isDark,
                          onChanged: (val) {
                            context.read<ThemeCubit>().setThemeMode(
                              val ? ThemeMode.dark : ThemeMode.light,
                            );
                          },
                          secondary: const Icon(
                            Icons.dark_mode_outlined,
                            color: AppColors.primary,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showLogoutDialog(context),
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.white),
                  ),
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: AppStrings.logout,
        message: AppStrings.confirmSignOut,
        onConfirm: () {
          context.read<AuthBloc>().add(LogoutRequested());
        },
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
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
