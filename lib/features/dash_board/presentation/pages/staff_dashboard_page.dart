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
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/features/department/data/datasource/doctor_staff_remote_datasource.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/dashboard_tab_cubit.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/navigation/staff_bottom_nav_bar.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/role_drawers.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/utils/profile_image_helper.dart';
import 'package:medi_connect/core/common_widgets/dialogs/dialogs.dart';
import 'package:medi_connect/core/themes/theme_cubit.dart';

class StaffDashboardPage extends StatefulWidget {
  const StaffDashboardPage({super.key});

  @override
  State<StaffDashboardPage> createState() => _StaffDashboardPageState();
}

class _StaffDashboardPageState extends State<StaffDashboardPage> {
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
                        AppStrings.staffDashboardTitle,
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : null,
              drawer: const StaffDrawer(),
              body: IndexedStack(
                index: currentIndex,
                children: [
                  const _StaffHomeTab(),
                  const _StaffTasksTab(),
                  const _StaffRosterTab(),
                  const _StaffAlertsTab(),
                  const _StaffProfileTab(),
                ],
              ),
              bottomNavigationBar: StaffBottomNavBar(
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
// Staff Home Tab
// ─────────────────────────────────────────────────────────────────────────────
class _StaffHomeTab extends StatelessWidget {
  const _StaffHomeTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StaffWelcomeBanner(),
          SizedBox(height: 20.h),
          Text(
            "Shift Information",
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          _StaffShiftCard(),
          SizedBox(height: 20.h),
          Text(
            "My Tasks Overview",
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          _StaffTasksOverviewCard(),
        ],
      ),
    );
  }
}

class _StaffWelcomeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String name = 'Staff Member';
        String? profileImage;
        String? roleLabel = 'Medical Support';

        if (state is Authenticated) {
          final user = state.user;
          name =
              user.name ??
              "${user.firstName ?? ''} ${user.lastName ?? ''}".trim();
          profileImage = user.profileImage;
          roleLabel = user.staffRole ?? 'Administrative Staff';
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: AppColors.staffGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.25),
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
                    SizedBox(height: 4.h),
                    Text(
                      roleLabel!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white70,
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
                    'staff',
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

class _StaffShiftCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String currentShift = "Day Shift (08:00 AM - 04:00 PM)";
        String statusLabel = "Active";

        if (state is Authenticated) {
          final user = UserModel.fromEntity(state.user);
          final roster = user.metadata?['roster'] as List<dynamic>?;
          if (roster != null && roster.isNotEmpty) {
            final days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
            final currentDayName = days[DateTime.now().weekday - 1];
            final shiftItem = roster.firstWhere(
              (item) => item is Map && item['day'] == currentDayName,
              orElse: () => null,
            );
            if (shiftItem != null && shiftItem is Map) {
              currentShift = (shiftItem['shift'] ?? '').toString();
              if (currentShift.toLowerCase().contains("off")) {
                statusLabel = "Off";
              }
            }
          }
        }

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: const BorderSide(color: AppColors.border),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Current Shift", style: AppTextStyles.bodySmall),
                    SizedBox(height: 4.h),
                    Text(
                      currentShift,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: statusLabel == "Off" ? AppColors.error.withOpacity(0.1) : AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusLabel == "Off" ? AppColors.error : AppColors.accent,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StaffTasksOverviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final List<Map<String, dynamic>> tasks = [];
        if (state is Authenticated) {
          final user = state.user;
          final metadataTasks = user.metadata?['tasks'] as List<dynamic>?;
          if (metadataTasks != null) {
            for (var item in metadataTasks) {
              if (item is Map) {
                tasks.add({
                  'title': (item['title'] ?? '').toString(),
                  'status': (item['status'] ?? '').toString(),
                });
              }
            }
          }
        }

        if (tasks.isEmpty) {
          tasks.addAll([
            {'title': 'Sanitize consultation room 3', 'status': 'Pending'},
            {'title': 'Verify outpatient logs', 'status': 'Completed'},
            {'title': 'Update stock checklist in Block A', 'status': 'Pending'},
          ]);
        }

        // Only show up to 3 tasks in the home overview card
        final tasksToShow = tasks.length > 3 ? tasks.sublist(0, 3) : tasks;

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
            side: const BorderSide(color: AppColors.border),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tasksToShow.length,
            separatorBuilder: (context, idx) =>
                const Divider(color: AppColors.border, height: 1),
            itemBuilder: (context, idx) {
              final t = tasksToShow[idx];
              final isCompleted = t['status'] == 'Completed';
              return ListTile(
                contentPadding: EdgeInsets.all(16.r),
                leading: Icon(
                  isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isCompleted ? AppColors.success : AppColors.textSecondary,
                ),
                title: Text(
                  t['title']!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                    fontWeight: isCompleted ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  t['status']!,
                  style: TextStyle(
                    color: isCompleted ? AppColors.success : AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Staff Tasks Tab
// ─────────────────────────────────────────────────────────────────────────────
class _StaffTasksTab extends StatelessWidget {
  const _StaffTasksTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! Authenticated) {
          return const Center(child: CircularProgressIndicator());
        }
        final user = UserModel.fromEntity(state.user);
        final metadataTasks = user.metadata?['tasks'] as List<dynamic>?;
        final List<Map<String, dynamic>> tasks = [];
        if (metadataTasks != null) {
          for (var item in metadataTasks) {
            if (item is Map) {
              tasks.add({
                'id': (item['id'] ?? '').toString(),
                'title': (item['title'] ?? '').toString(),
                'status': (item['status'] ?? '').toString(),
              });
            }
          }
        } else {
          tasks.addAll([
            {'id': 'T-1', 'title': 'Sanitize consultation room 3', 'status': 'Pending'},
            {'id': 'T-2', 'title': 'Verify outpatient logs', 'status': 'Completed'},
            {
              'id': 'T-3',
              'title': 'Update stock checklist in Block A',
              'status': 'Pending',
            },
            {
              'id': 'T-4',
              'title': 'Confirm receipt of lab reagents',
              'status': 'Pending',
            },
          ]);
        }

        return Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My Tasks",
                style: AppTextStyles.headingMedium.copyWith(fontSize: 22.sp),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, idx) {
                    final t = tasks[idx];
                    final isCompleted = t['status'] == 'Completed';

                    return Card(
                      margin: EdgeInsets.only(bottom: 12.h),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: const BorderSide(color: AppColors.border),
                      ),
                      child: CheckboxListTile(
                        activeColor: AppColors.primary,
                        value: isCompleted,
                        onChanged: (val) async {
                          final updatedMetadata = Map<String, dynamic>.from(user.metadata ?? {});
                          final updatedTasks = List<dynamic>.from(updatedMetadata['tasks'] ?? [
                            {'id': 'T-1', 'title': 'Sanitize consultation room 3', 'status': 'Pending'},
                            {'id': 'T-2', 'title': 'Verify outpatient logs', 'status': 'Completed'},
                            {
                              'id': 'T-3',
                              'title': 'Update stock checklist in Block A',
                              'status': 'Pending',
                            },
                            {
                              'id': 'T-4',
                              'title': 'Confirm receipt of lab reagents',
                              'status': 'Pending',
                            },
                          ]);

                          final taskIdx = updatedTasks.indexWhere((item) => item['id'] == t['id']);
                          if (taskIdx != -1) {
                            final updatedTask = Map<String, dynamic>.from(updatedTasks[taskIdx]);
                            updatedTask['status'] = val! ? 'Completed' : 'Pending';
                            updatedTasks[taskIdx] = updatedTask;
                          }

                          updatedMetadata['tasks'] = updatedTasks;
                          final updatedUser = user.copyWith(metadata: updatedMetadata);

                          // Save to DB
                          await GetIt.instance<DoctorStaffRemoteDataSource>().updateDoctorStaffMember(updatedUser);

                          // Update Auth state
                          if (context.mounted) {
                            context.read<AuthBloc>().add(UserUpdated(updatedUser));
                          }
                        },
                        title: Text(
                          t['title']!,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isCompleted
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: Text("Task ID: ${t['id']!}"),
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
// Staff Roster Tab
// ─────────────────────────────────────────────────────────────────────────────
class _StaffRosterTab extends StatelessWidget {
  const _StaffRosterTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! Authenticated) {
          return const Center(child: CircularProgressIndicator());
        }
        final user = UserModel.fromEntity(state.user);
        final metadataRoster = user.metadata?['roster'] as List<dynamic>?;
        final List<Map<String, String>> roster = [];

        if (metadataRoster != null) {
          for (var item in metadataRoster) {
            if (item is Map) {
              roster.add({
                'day': (item['day'] ?? '').toString(),
                'shift': (item['shift'] ?? '').toString(),
                'dept': (item['dept'] ?? '').toString(),
              });
            }
          }
        }

        if (roster.isEmpty) {
          roster.addAll([
            {
              'day': 'Monday',
              'shift': 'Day Shift (08:00 AM - 04:00 PM)',
              'dept': 'OPD Support',
            },
            {
              'day': 'Tuesday',
              'shift': 'Day Shift (08:00 AM - 04:00 PM)',
              'dept': 'OPD Support',
            },
            {'day': 'Wednesday', 'shift': 'Off Day', 'dept': '-'},
            {
              'day': 'Thursday',
              'shift': 'Night Shift (08:00 PM - 04:00 AM)',
              'dept': 'Emergency Wards',
            },
            {
              'day': 'Friday',
              'shift': 'Night Shift (08:00 PM - 04:00 AM)',
              'dept': 'Emergency Wards',
            },
          ]);
        }

        return Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Shift Roster",
                style: AppTextStyles.headingMedium.copyWith(fontSize: 22.sp),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.builder(
                  itemCount: roster.length,
                  itemBuilder: (context, idx) {
                    final r = roster[idx];
                    final isOff = r['shift'] == 'Off Day';

                    return InkWell(
                      onTap: () {
                        // Interactive Shift Change dialog
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            final shiftCtrl = TextEditingController(text: r['shift']);
                            final deptCtrl = TextEditingController(text: r['dept']);

                            return AlertDialog(
                              title: Text("Edit Shift for ${r['day']}"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: shiftCtrl,
                                    decoration: const InputDecoration(labelText: "Shift Timing"),
                                  ),
                                  TextField(
                                    controller: deptCtrl,
                                    decoration: const InputDecoration(labelText: "Department"),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(ctx);
                                    final updatedMetadata = Map<String, dynamic>.from(user.metadata ?? {});
                                    final updatedRoster = List<dynamic>.from(updatedMetadata['roster'] ?? [
                                      {
                                        'day': 'Monday',
                                        'shift': 'Day Shift (08:00 AM - 04:00 PM)',
                                        'dept': 'OPD Support',
                                      },
                                      {
                                        'day': 'Tuesday',
                                        'shift': 'Day Shift (08:00 AM - 04:00 PM)',
                                        'dept': 'OPD Support',
                                      },
                                      {'day': 'Wednesday', 'shift': 'Off Day', 'dept': '-'},
                                      {
                                        'day': 'Thursday',
                                        'shift': 'Night Shift (08:00 PM - 04:00 AM)',
                                        'dept': 'Emergency Wards',
                                      },
                                      {
                                        'day': 'Friday',
                                        'shift': 'Night Shift (08:00 PM - 04:00 AM)',
                                        'dept': 'Emergency Wards',
                                      },
                                    ]);

                                    updatedRoster[idx] = {
                                      'day': r['day']!,
                                      'shift': shiftCtrl.text,
                                      'dept': deptCtrl.text,
                                    };

                                    updatedMetadata['roster'] = updatedRoster;
                                    final updatedUser = user.copyWith(metadata: updatedMetadata);

                                    // Save changes
                                    await GetIt.instance<DoctorStaffRemoteDataSource>().updateDoctorStaffMember(updatedUser);

                                    // Trigger session state updates
                                    if (context.mounted) {
                                      context.read<AuthBloc>().add(UserUpdated(updatedUser));
                                    }
                                  },
                                  child: const Text("Save"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: isOff ? AppColors.divider : AppColors.surface,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r['day']!,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(r['shift']!, style: AppTextStyles.bodySmall),
                                if (!isOff)
                                  Text(
                                    "Dept: ${r['dept']!}",
                                    style: AppTextStyles.bodySmall,
                                  ),
                              ],
                            ),
                            Icon(
                              isOff
                                  ? Icons.home_outlined
                                  : Icons.calendar_month_outlined,
                              color: isOff
                                  ? AppColors.textSecondary
                                  : AppColors.accent,
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
// Staff Alerts Tab
// ─────────────────────────────────────────────────────────────────────────────
class _StaffAlertsTab extends StatelessWidget {
  const _StaffAlertsTab();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> alerts = [
      {
        'message': 'Code Blue in Emergency Ward - Room 108',
        'time': '2m ago',
        'level': 'Critical',
      },
      {
        'message': 'Intense Patient Influx in ICU - Staff assistance requested',
        'time': '15m ago',
        'level': 'High',
      },
    ];

    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Emergency Messages",
            style: AppTextStyles.headingMedium.copyWith(fontSize: 22.sp),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView.builder(
              itemCount: alerts.length,
              itemBuilder: (context, idx) {
                final alert = alerts[idx];
                Color levelColor = alert['level'] == 'Critical'
                    ? AppColors.error
                    : AppColors.warning;

                return Card(
                  margin: EdgeInsets.only(bottom: 12.h),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(color: levelColor.withOpacity(0.4)),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.r),
                    leading: Icon(Icons.warning, color: levelColor),
                    title: Text(
                      alert['message']!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text("Triggered: ${alert['time']!}"),
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
// Staff Profile Tab
// ─────────────────────────────────────────────────────────────────────────────
class _StaffProfileTab extends StatelessWidget {
  const _StaffProfileTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String name = "Staff Member";
        String email = "staff@mediconnect.com";
        String? phone = "+91 98765 43210";
        String? roleLabel = "Clinic Operations";
        String? profileImage;

        if (state is Authenticated) {
          final user = state.user;
          name =
              user.name ??
              "${user.firstName ?? ''} ${user.lastName ?? ''}".trim();
          email = user.email;
          phone = user.phoneNumber;
          roleLabel = user.staffRole;
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
                  border: Border.all(color: AppColors.accent, width: 3),
                ),
                child: CustomImageView(
                  imagePath: ProfileImageHelper.resolveImagePath(
                    profileImage,
                    'staff',
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
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  roleLabel ?? 'Administrative Staff',
                  style: TextStyle(
                    color: AppColors.accent,
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
                    _buildInfoTile(
                      Icons.phone_outlined,
                      "Phone",
                      phone ?? "Not Set",
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    _buildInfoTile(
                      Icons.badge_outlined,
                      "Staff ID",
                      "STF-2819",
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    _buildInfoTile(
                      Icons.work_history_outlined,
                      "Joining Date",
                      "Feb 20, 2025",
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
                            color: AppColors.accent,
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
      leading: Icon(icon, color: AppColors.accent),
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
