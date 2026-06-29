import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/functions/profile_image_helper.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/core/widgets/dialogs/dialogs.dart';
import 'package:medi_connect/core/theme/theme_cubit.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/common/dashboard_tab_cubit.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/navigation/patient_bottom_nav_bar.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_home_tab.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_booking_bottom_sheet.dart';
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
                  PatientHomeTab(),
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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! Authenticated) {
          return const Center(child: CircularProgressIndicator());
        }
        final user = UserModel.fromEntity(state.user);
        final metadataApts=null;
        final List<Map<String, String>> appointments = [];
        if (metadataApts != null) {
          for (var item in metadataApts) {
            if (item is Map) {
              appointments.add({
                'doctor': (item['doctor'] ?? '').toString(),
                'specialty': (item['specialty'] ?? '').toString(),
                'time': (item['time'] ?? '').toString(),
                'type': (item['type'] ?? '').toString(),
              });
            }
          }
        } else {
          appointments.addAll([
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
          ]);
        }

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
                    style: AppTextStyles.headingMedium.copyWith(
                      fontSize: 22.sp,
                    ),
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
                  itemCount: appointments.length,
                  itemBuilder: (context, idx) {
                    final apt = appointments[idx];
                    return Card(
                      margin: EdgeInsets.only(bottom: 12.h),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: BorderSide(color: AppColors.border(context)),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.r),
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.1,
                          ),
                          child: Icon(Icons.person, color: AppColors.primary),
                        ),
                        title: Text(
                          apt['doctor']!,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                        subtitle: Text(
                          "${apt['specialty']!} | ${apt['type']!}",
                        ),
                        trailing: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
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
      },
    );
  }

  void _showBookDoctorDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PatientBookingBottomSheet(),
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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final List<Map<String, String>> records = [];
        if (state is Authenticated) {
          final user = state.user;
          final metadataRecs =null;
          if (metadataRecs != null) {
            for (var item in metadataRecs) {
              if (item is Map) {
                records.add({
                  'title': (item['title'] ?? '').toString(),
                  'date': (item['date'] ?? '').toString(),
                  'type': (item['type'] ?? '').toString(),
                  'doctor': (item['doctor'] ?? '').toString(),
                });
              }
            }
          }
        }

        if (records.isEmpty) {
          records.addAll([
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
          ]);
        }

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
                        side: BorderSide(color: AppColors.border(context)),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.r),
                        leading: Container(
                          padding: EdgeInsets.all(10.r),
                          decoration: BoxDecoration(
                            color:
                                (isLab ? AppColors.secondary : AppColors.accent)
                                    .withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isLab
                                ? Icons.science_outlined
                                : Icons.description_outlined,
                            color: isLab
                                ? AppColors.secondary
                                : AppColors.accent,
                          ),
                        ),
                        title: Text(
                          rec['title']!,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary(context),
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
      },
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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final List<Map<String, String>> chats = [];
        if (state is Authenticated) {
          final user = state.user;
          final metadataChats = null;
          if (metadataChats != null) {
            for (var item in metadataChats) {
              if (item is Map) {
                chats.add({
                  'doctor': (item['doctor'] ?? '').toString(),
                  'specialty': (item['specialty'] ?? '').toString(),
                  'lastMsg': (item['lastMsg'] ?? '').toString(),
                  'time': (item['time'] ?? '').toString(),
                });
              }
            }
          }
        }

        if (chats.isEmpty) {
          chats.addAll([
            {
              'doctor': 'Dr. Sarah Johnson',
              'specialty': 'Cardiologist',
              'lastMsg':
                  'Your ECG looks normal, please continue the medication.',
              'time': 'Yesterday',
            },
            {
              'doctor': 'Dr. Michael Chen',
              'specialty': 'Neurologist',
              'lastMsg':
                  'Let\'s schedule a checkup next week if headache persists.',
              'time': '3 days ago',
            },
          ]);
        }

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
                        side: BorderSide(color: AppColors.border(context)),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.r),
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.1,
                          ),
                          child: Icon(Icons.person, color: AppColors.primary),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ch['doctor']!,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary(context),
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
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
      },
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
              user.fullName 
              ;
          email = user.email??"";
          phone = user.phone;
          profileImage = user.phone;
          bloodGroup = user.bloodGroup ?? 'O+';
          allergies = 'No Known Allergies';
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
                  side: BorderSide(color: AppColors.border(context)),
                ),
                child: Column(
                  children: [
                    _buildInfoTile(
                      Icons.phone_outlined,
                      "Phone",
                      phone ?? "Not Set",
                      context,
                    ),
                    Divider(color: AppColors.border(context), height: 1),
                    _buildInfoTile(
                      Icons.bloodtype_outlined,
                      "Blood Group",
                      bloodGroup,
                      context,
                    ),
                    Divider(color: AppColors.border(context), height: 1),
                    _buildInfoTile(
                      Icons.warning_amber_rounded,
                      "Allergies",
                      allergies,
                      context,
                    ),
                    Divider(color: AppColors.border(context), height: 1),
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

  Widget _buildInfoTile(
    IconData icon,
    String title,
    String value,
    BuildContext context,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary(context),
        ),
      ),
      trailing: Text(
        value,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary(context),
        ),
      ),
    );
  }
}
