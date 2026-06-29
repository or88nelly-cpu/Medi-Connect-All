import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_enum.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/functions/profile_image_helper.dart';
import 'package:medi_connect/core/widgets/dialogs/dialogs.dart';

import 'package:medi_connect/core/theme/theme_cubit.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String name = "Administrator";
        String email = "admin@mediconnect.com";
        String? phone = "+91 98765 43210";
        String? profileImage;
        String accessLevel = "Super Admin";

        if (state is Authenticated) {
          final user = state.user;
          name =
              user.fullName 
             ;
          email = user.email??"";
          phone = user.phone;
          profileImage = user.profilePhoto;
          accessLevel =user.role.value.toUpperCase()
              ;
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            children: [
              Text(
                AppStrings.profile,
                style: AppTextStyles.headingMedium.copyWith(fontSize: 22.sp),
              ),
              SizedBox(height: 20.h),
              Center(
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
                          'admin',
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        accessLevel,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                      Icons.badge_outlined,
                      "Employee ID",
                      "EMP-ADMIN-01",
                      context,
                    ),
                    Divider(color: AppColors.border(context), height: 1),
                    _buildInfoTile(
                      Icons.calendar_month_outlined,
                      "Joining Date",
                      "Jan 15, 2025",
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
