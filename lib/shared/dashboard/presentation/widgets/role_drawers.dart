import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/widgets/dialogs/dialogs.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/functions/profile_image_helper.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/common/dashboard_tab_cubit.dart';

/// Patient-role side drawer.
class PatientDrawer extends StatelessWidget {
  const PatientDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background(context),
      child: Column(
        children: [
          _RoleDrawerHeader(
            gradient: AppColors.patientGradient,
            roleLabel: 'Patient',
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerItem(
                  icon: Icons.home_outlined,
                  title: 'Home',
                  onTap: () {
                    context.read<DashboardTabCubit>().setTab(0);
                    context.pop();
                  },
                ),
                _DrawerItem(
                  icon: Icons.calendar_today_outlined,
                  title: 'Appointments',
                  onTap: () {
                    context.pop();
                    context.push('/departments');
                  },
                ),
                _DrawerItem(
                  icon: Icons.folder_open_outlined,
                  title: 'Medical Records',
                  onTap: () {
                    context.pop();
                  },
                ),
                _DrawerItem(
                  icon: Icons.local_hospital_outlined,
                  title: 'Departments',
                  onTap: () {
                    context.pop();
                    context.push('/departments');
                  },
                ),
                _DrawerItem(
                  icon: Icons.chat_bubble_outline,
                  title: 'Chat',
                  onTap: () {
                    context.pop();
                  },
                ),
                Divider(color: AppColors.border(context)),
                _DrawerItem(
                  icon: Icons.person_outline,
                  title: 'Profile',
                  onTap: () {
                    context.read<DashboardTabCubit>().setTab(4);
                    context.pop();
                  },
                ),
                _DrawerItem(
                  icon: Icons.logout,
                  title: AppStrings.logout,
                  iconColor: AppColors.error,
                  textColor: AppColors.error,
                  onTap: () {
                    context.pop();
                    _showLogout(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: AppStrings.logout,
        message: AppStrings.confirmSignOut,
        onConfirm: () => context.read<AuthBloc>().add(LogoutRequested()),
      ),
    );
  }
}

/// Doctor-role side drawer.
class DoctorDrawer extends StatelessWidget {
  const DoctorDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background(context),
      child: Column(
        children: [
          _RoleDrawerHeader(
            gradient: AppColors.doctorGradient,
            roleLabel: 'Doctor',
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerItem(
                  icon: Icons.home_outlined,
                  title: 'Home',
                  onTap: () {
                    context.read<DashboardTabCubit>().setTab(0);
                    context.pop();
                  },
                ),
                _DrawerItem(
                  icon: Icons.schedule_outlined,
                  title: "Today's Schedule",
                  onTap: () {
                    context.read<DashboardTabCubit>().setTab(1);
                    context.pop();
                  },
                ),
                _DrawerItem(
                  icon: Icons.people_outline,
                  title: 'My Patients',
                  onTap: () {
                    context.read<DashboardTabCubit>().setTab(2);
                    context.pop();
                  },
                ),
                _DrawerItem(
                  icon: Icons.video_call_outlined,
                  title: 'Video Consults',
                  onTap: () {
                    context.pop();
                  },
                ),
                _DrawerItem(
                  icon: Icons.local_hospital_outlined,
                  title: 'Departments',
                  onTap: () {
                    context.pop();
                    context.push('/departments');
                  },
                ),
                Divider(color: AppColors.border(context)),
                _DrawerItem(
                  icon: Icons.person_outline,
                  title: 'Profile',
                  onTap: () {
                    context.read<DashboardTabCubit>().setTab(4);
                    context.pop();
                  },
                ),
                _DrawerItem(
                  icon: Icons.logout,
                  title: AppStrings.logout,
                  iconColor: AppColors.error,
                  textColor: AppColors.error,
                  onTap: () {
                    context.pop();
                    _showLogout(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: AppStrings.logout,
        message: AppStrings.confirmSignOut,
        onConfirm: () => context.read<AuthBloc>().add(LogoutRequested()),
      ),
    );
  }
}

/// Staff-role side drawer.
class StaffDrawer extends StatelessWidget {
  const StaffDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background(context),
      child: Column(
        children: [
          _RoleDrawerHeader(
            gradient: AppColors.staffGradient,
            roleLabel: 'Staff',
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerItem(
                  icon: Icons.home_outlined,
                  title: 'Home',
                  onTap: () {
                    context.read<DashboardTabCubit>().setTab(0);
                    context.pop();
                  },
                ),
                _DrawerItem(
                  icon: Icons.task_outlined,
                  title: 'My Tasks',
                  onTap: () {
                    context.read<DashboardTabCubit>().setTab(1);
                    context.pop();
                  },
                ),
                _DrawerItem(
                  icon: Icons.grid_view_outlined,
                  title: 'Roster',
                  onTap: () {
                    context.read<DashboardTabCubit>().setTab(2);
                    context.pop();
                  },
                ),
                _DrawerItem(
                  icon: Icons.local_hospital_outlined,
                  title: 'Departments',
                  onTap: () {
                    context.pop();
                    context.push('/departments');
                  },
                ),
                _DrawerItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  onTap: () {
                    context.pop();
                  },
                ),
                Divider(color: AppColors.border(context)),
                _DrawerItem(
                  icon: Icons.person_outline,
                  title: 'Profile',
                  onTap: () {
                    context.read<DashboardTabCubit>().setTab(4);
                    context.pop();
                  },
                ),
                _DrawerItem(
                  icon: Icons.logout,
                  title: AppStrings.logout,
                  iconColor: AppColors.error,
                  textColor: AppColors.error,
                  onTap: () {
                    context.pop();
                    _showLogout(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: AppStrings.logout,
        message: AppStrings.confirmSignOut,
        onConfirm: () => context.read<AuthBloc>().add(LogoutRequested()),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared drawer header with role-specific gradient.
// ─────────────────────────────────────────────────────────────────────────────
class _RoleDrawerHeader extends StatelessWidget {
  final List<Color> gradient;
  final String roleLabel;

  const _RoleDrawerHeader({required this.gradient, required this.roleLabel});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String name = roleLabel;
        String email = '';
        String? profileImage;

        if (state is Authenticated) {
          final user = state.user;
          name =
              user.name ??
              (user.firstName != null
                  ? '${user.firstName} ${user.lastName ?? ''}'.trim()
                  : roleLabel);
          email = user.email;
          profileImage = user.profileImage;
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: 50.h,
            left: 20.w,
            right: 20.w,
            bottom: 20.h,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60.r,
                height: 60.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 2),
                ),
                child: CustomImageView(
                  imagePath: ProfileImageHelper.resolveImagePath(
                    profileImage,
                    state is Authenticated ? state.user.role : 'patient',
                    state is Authenticated ? state.user.gender : null,
                  ),
                  borderRadius: 30.r,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                name,
                style: AppTextStyles.titleLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (email.isNotEmpty)
                Text(
                  email,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white70,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  roleLabel,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
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
// Reusable drawer list tile.
// ─────────────────────────────────────────────────────────────────────────────
class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? AppColors.textPrimary(context),
        size: 22.r,
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: textColor ?? AppColors.textPrimary(context),
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }
}
