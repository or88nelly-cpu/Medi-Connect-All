import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/common_app_bar.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/utils/profile_image_helper.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/doctor_profile/doctor_profile_admin_view.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_state.dart';

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

        final isDoctor = currentUser.role == 'doctor';
        if (isDoctor) {
          return DoctorProfileAdminView(user: currentUser);
        }

        final roleColor = isDoctor ? AppColors.secondary : AppColors.accent;

        return CustomScaffold(
          customAppbar: CommonAppBar(
            title: "${currentUser.role.toUpperCase()} Details",
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
                            currentUser.profileImage,
                            currentUser.role,
                            currentUser.gender,
                          ),
                          borderRadius: 50.r,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        currentUser.name ??
                            "${currentUser.firstName ?? ''} ${currentUser.lastName ?? ''}"
                                .trim(),
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(currentUser.email, style: AppTextStyles.bodyMedium),
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
                          currentUser.role.toUpperCase(),
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
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        "Phone",
                        currentUser.phoneNumber ?? "Not Set",
                      ),
                      const Divider(color: AppColors.border, height: 1),
                      _buildInfoRow("Gender", currentUser.gender ?? "Not Set"),
                      const Divider(color: AppColors.border, height: 1),
                      _buildInfoRow(
                        "Department",
                        currentUser.department ?? "Not Assigned",
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
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        "Staff Role",
                        currentUser.staffRole ?? "Not Set",
                      ),
                      const Divider(color: AppColors.border, height: 1),
                      _buildInfoRow(
                        "Designation",
                        currentUser.designation ?? "Not Set",
                      ),
                      const Divider(color: AppColors.border, height: 1),
                      _buildInfoRow(
                        "Shift",
                        currentUser.availabilityStatus ?? "Day Shift",
                      ),
                      const Divider(color: AppColors.border, height: 1),
                      _buildInfoRow("Status", currentUser.status),
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

  Widget _buildInfoRow(String title, String value) {
    return ListTile(
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
