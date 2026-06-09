  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/common_widgets/dialogs/dialogs.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/utils/profile_image_helper.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';

import '../bloc/dashboard_tab_cubit.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
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
                const Divider(color: AppColors.border),
                _buildSectionHeader("Management"),
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
                const Divider(color: AppColors.border),
                _buildSectionHeader("Operations"),
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
                const Divider(color: AppColors.border),
                _buildSectionHeader("Account"),
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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String name = "Administrator";
        String email = "admin@mediconnect.com";
        String? profileImage;
        String accessLevel = "Super Admin";

        if (state is Authenticated) {
          final user = state.user;
          name = user.name ?? (user.firstName != null ? "${user.firstName} ${user.lastName ?? ''}".trim() : "Administrator");
          email = user.email;
          profileImage = user.profileImage;
          accessLevel = user.accessLevel ?? (user.role == 'admin' ? "Super Admin" : user.role.toUpperCase());
        }

        final initials = name.isNotEmpty ? name[0].toUpperCase() : "A";

        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 50.h, left: 20.w, right: 20.w, bottom: 20.h),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.adminGradient,
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
                      border: Border.all(color: Colors.white24, width: 2),
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
                    icon: const Icon(Icons.edit_outlined, color: Colors.white),
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
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                email,
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
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
                  accessLevel,
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
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
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.textPrimary, size: 22.r),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: textColor ?? AppColors.textPrimary,
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
