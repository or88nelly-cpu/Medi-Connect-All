import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/common_app_bar.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/utils/profile_image_helper.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/doctor_profile/doctor_profile_admin_view.dart';

class DoctorStaffDetailPage extends StatelessWidget {
  const DoctorStaffDetailPage({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final isDoctor = user.role == 'doctor';
    if (isDoctor) {
      return DoctorProfileAdminView(user: user);
    }
    
    final roleColor = isDoctor ? AppColors.secondary : AppColors.accent;

    return CustomScaffold(
      customAppbar: CommonAppBar(title: "${user.role.toUpperCase()} Details"),
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
                        user.profileImage,
                        user.role,
                        user.gender,
                      ),
                      borderRadius: 50.r,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    user.name ??
                        "${user.firstName ?? ''} ${user.lastName ?? ''}".trim(),
                    style: AppTextStyles.titleLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(user.email, style: AppTextStyles.bodyMedium),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: roleColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      user.role.toUpperCase(),
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
                  _buildInfoRow("Phone", user.phoneNumber ?? "Not Set"),
                  const Divider(color: AppColors.border, height: 1),
                  _buildInfoRow("Gender", user.gender ?? "Not Set"),
                  const Divider(color: AppColors.border, height: 1),
                  _buildInfoRow(
                    "Department",
                    user.department ?? "Not Assigned",
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
                  if (isDoctor) ...[
                    _buildInfoRow(
                      "Specialization",
                      user.specialization ?? "Not Set",
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    _buildInfoRow(
                      "Qualifications",
                      user.qualification ?? "Not Set",
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    _buildInfoRow(
                      "Consultation Fee",
                      user.consultationFee != null
                          ? "₹ ${user.consultationFee}"
                          : "Not Set",
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    _buildInfoRow(
                      "Experience",
                      user.experience != null
                          ? "${user.experience} Years"
                          : "Not Set",
                    ),
                  ] else ...[
                    _buildInfoRow("Staff Role", user.staffRole ?? "Not Set"),
                    const Divider(color: AppColors.border, height: 1),
                    _buildInfoRow("Designation", user.designation ?? "Not Set"),
                    const Divider(color: AppColors.border, height: 1),
                    _buildInfoRow(
                      "Shift",
                      user.availabilityStatus ?? "Day Shift",
                    ),
                  ],
                  const Divider(color: AppColors.border, height: 1),
                  _buildInfoRow("Status", user.status),
                ],
              ),
            ),
          ],
        ),
      ),
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
