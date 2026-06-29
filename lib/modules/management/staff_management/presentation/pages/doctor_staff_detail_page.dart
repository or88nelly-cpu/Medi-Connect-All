import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_enum.dart';
import 'package:medi_connect/core/widgets/appbar/common_app_bar.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/functions/profile_image_helper.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_profile/doctor_profile_admin_view.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_state.dart';

class DoctorStaffDetailPage extends StatelessWidget {
  const DoctorStaffDetailPage({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorStaffBloc, DoctorStaffState>(
      builder: (context, state) {
        UserModel currentUser = user;
        if (state is DoctorStaffLoaded) {
          final docList = state.doctors.where((u) => u.id == user.id);
          if (docList.isNotEmpty) {
            currentUser = docList.first;
          } else {
            final staffList = state.staff.where((u) => u.id == user.id);
            if (staffList.isNotEmpty) {
              currentUser = staffList.first;
            }
          }
        }

        final isDoctor = currentUser.role == UserRole.doctor;
        if (isDoctor) {
          return DoctorProfileAdminView(user: currentUser);
        }

        final roleColor = isDoctor ? AppColors.secondary : AppColors.accent;

        return CustomScaffold(
          customAppbar: CommonAppBar(
            title: "${currentUser.role.value.toUpperCase()} Details",
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20.r),
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100.r,
                        height: 100.r,
                        decoration: BoxDecoration(
                           shape: BoxShape.circle,
                           border: Border.all(color: roleColor, width: 3),
                        ),
                        child: CustomImageView(
                          imagePath: ProfileImageHelper.resolveImagePath(
                            currentUser.profilePhoto,
                            currentUser.role.value,
                            currentUser.gender,
                          ),
                          borderRadius: 50.r,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        currentUser.fullName.trim(),
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(currentUser.email ?? '', style: AppTextStyles.bodyMedium),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: roleColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          currentUser.role.value.toUpperCase(),
                          style: TextStyle(
                            color: roleColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                _buildSectionHeader("Basic Information"),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(color: AppColors.border(context)),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        "Phone",
                        currentUser.phone ?? "Not Set",
                        context,
                      ),
                      Divider(color: AppColors.border(context), height: 1),
                      _buildInfoRow(
                        "Gender",
                        currentUser.gender ?? "Not Set",
                        context,
                      ),
                      Divider(color: AppColors.border(context), height: 1),
                      _buildInfoRow(
                        "Department",
                        "Human Resource",
                        context,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                _buildSectionHeader("Professional Information"),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(color: AppColors.border(context)),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        "Staff Role",
                        currentUser.role.value,
                        context,
                      ),
                      Divider(color: AppColors.border(context), height: 1),
                      _buildInfoRow(
                        "Designation",
                        "Support Staff",
                        context,
                      ),
                      Divider(color: AppColors.border(context), height: 1),
                      _buildInfoRow(
                        "Shift",
                        "Day Shift",
                        context,
                      ),
                      Divider(color: AppColors.border(context), height: 1),
                      _buildInfoRow("Status", currentUser.status ?? 'Active', context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
        child: Text(
          title,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, BuildContext context) {
    return ListTile(
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
