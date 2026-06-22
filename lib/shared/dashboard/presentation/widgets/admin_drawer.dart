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

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final drawerBg = isDark
        ? AppColors.terminalDarkBg
        : AppColors.terminalLightBg;
    final dividerColor = isDark
        ? AppColors.terminalDarkBorder
        : AppColors.terminalLightBorder;

    return Drawer(
      backgroundColor: drawerBg,
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.dashboard_outlined,
                  title: "Dashboard Home",
                  onTap: () {
                    context.read<DashboardTabCubit>().setTab(0);
                    context.pop();
                  },
                ),
                Divider(color: dividerColor),
                _buildSectionHeader(context, "Management"),
                _buildDrawerItem(
                  context,
                  icon: Icons.local_hospital_outlined,
                  title: "Doctors Directory",
                  onTap: () {
                    context.pop();
                    context.push('/admin/doctors');
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.badge_outlined,
                  title: "Staff Directory",
                  onTap: () {
                    context.pop();
                    context.push('/admin/staff');
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.people_outline,
                  title: "Patients Directory",
                  onTap: () {
                    context.pop();
                    context.push('/admin/patients');
                  },
                ),
                Divider(color: dividerColor),
                _buildSectionHeader(context, "Operations"),
                _buildDrawerItem(
                  context,
                  icon: Icons.calendar_month_outlined,
                  title: "Slot Config",
                  onTap: () {
                    context.pop();
                    context.push('/admin/slot-config');
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.medication_outlined,
                  title: "Pharmacy Stocks",
                  onTap: () {
                    context.pop();
                    context.push('/admin/pharmacy');
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.science_outlined,
                  title: "Laboratory",
                  onTap: () {
                    context.pop();
                    context.push('/admin/labs');
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.co_present_outlined,
                  title: "Staff Attendance Logs",
                  onTap: () {
                    context.pop();
                    context.push('/admin/staff-attendance');
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.history_toggle_off_outlined,
                  title: "Recent Activity Logs",
                  onTap: () {
                    context.pop();
                    context.push('/admin/recent-activity');
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.warning_amber_rounded,
                  title: "Active Emergencies",
                  onTap: () {
                    context.pop();
                    context.push('/admin/emergencies');
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.analytics_outlined,
                  title: "Audit Logs",
                  onTap: () {
                    context.pop();
                    context.push('/admin/audit-logs');
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.history_toggle_off_outlined,
                  title: "Notification Logs",
                  onTap: () {
                    context.pop();
                    context.push('/admin/notifications');
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings_suggest_outlined,
                  title: "Master Data",
                  onTap: () {
                    context.pop();
                    context.push('/admin/master-data');
                  },
                ),
                Divider(color: dividerColor),
                _buildSectionHeader(context, "Account"),
                _buildDrawerItem(
                  context,
                  icon: Icons.person_outline,
                  title: "Edit Profile",
                  onTap: () {
                    context.read<DashboardTabCubit>().setTab(4);
                    context.pop();
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.logout,
                  title: "Sign Out",
                  iconColor: AppColors.error,
                  textColor: AppColors.error,
                  onTap: () {
                    context.pop();
                    _showLogoutDialog(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final headerGradients = isDark
        ? [AppColors.terminalDarkBgGrad1, AppColors.terminalDarkBgGrad2]
        : [AppColors.terminalLightBgGrad1, AppColors.terminalLightBgGrad2];

    final textColor = isDark ? Colors.white : AppColors.terminalLightText;
    final subColor = isDark ? Colors.white70 : AppColors.terminalLightLabel;
    final iconColor = isDark ? Colors.white : AppColors.terminalLightText;
    final borderCol = isDark
        ? AppColors.terminalAccentCyan.withValues(alpha: 0.5)
        : AppColors.primary.withValues(alpha: 0.3);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String name = "Administrator";
        String email = "admin@mediconnect.com";
        String? profileImage;
        String accessLevel = "Super Admin";

        if (state is Authenticated) {
          final user = state.user;
          name =
              user.name ??
              (user.firstName != null
                  ? "${user.firstName} ${user.lastName ?? ''}".trim()
                  : "Administrator");
          email = user.email;
          profileImage = user.profileImage;
          accessLevel =
              user.accessLevel ??
              (user.role == 'admin' ? "Super Admin" : user.role.toUpperCase());
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
              colors: headerGradients,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60.r,
                    height: 60.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: borderCol, width: 2),
                    ),
                    child: CustomImageView(
                      imagePath: ProfileImageHelper.resolveImagePath(
                        profileImage,
                        state is Authenticated ? state.user.role : 'admin',
                        state is Authenticated ? state.user.gender : null,
                      ),
                      borderRadius: 30.r,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.edit_outlined, color: iconColor),
                    onPressed: () {
                      context.read<DashboardTabCubit>().setTab(4);
                      context.pop();
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                name,
                style: AppTextStyles.titleLarge.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                email,
                style: AppTextStyles.bodySmall.copyWith(color: subColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white12 : Colors.black12,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  accessLevel,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: textColor,
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

  Widget _buildSectionHeader(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark
        ? AppColors.terminalDarkLabel
        : AppColors.terminalLightLabel;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.bodySmall.copyWith(
          color: labelColor,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultTextColor = isDark
        ? AppColors.terminalDarkText
        : AppColors.terminalLightText;
    final defaultLabelColor = isDark
        ? AppColors.terminalDarkLabel
        : AppColors.terminalLightLabel;

    return ListTile(
      leading: Icon(icon, color: iconColor ?? defaultLabelColor, size: 22.r),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: textColor ?? defaultTextColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
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
}
