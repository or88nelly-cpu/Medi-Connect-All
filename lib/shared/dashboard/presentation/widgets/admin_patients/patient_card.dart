import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/functions/date_utils.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/functions/profile_image_helper.dart';

class PatientCard extends StatelessWidget {
  const PatientCard({
    super.key,
    required this.patient,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final UserModel patient;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark
        ? AppColors.terminalDarkCard
        : AppColors.terminalLightCard;
    final borderColor = isDark
        ? AppColors.terminalDarkBorder
        : AppColors.terminalLightBorder;
    final textColor = isDark
        ? AppColors.terminalDarkText
        : AppColors.terminalLightText;
    final labelColor = isDark
        ? AppColors.terminalDarkLabel
        : AppColors.terminalLightLabel;

    final status = patient.status;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: isDark ? Colors.white12 : Colors.black12,
                child: ClipOval(
                  child: CustomImageView(
                    imagePath: ProfileImageHelper.resolveImagePath(
                      patient.profilePhoto,
                      'patient',
                      patient.gender,
                    ),
                    width: 48.r,
                    height: 48.r,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.fullName ?? 'Unnamed Patient',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            patient.id ?? 'PAT-N/A',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Age: ${AppDateUtils.calculateAge(patient.dob)} | Blood: ${patient.bloodGroup ?? 'N/A'} | Phone: ${patient.phone ?? 'N/A'}",
                      style: TextStyle(color: labelColor, fontSize: 11.sp),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildStatusPill(status ?? ""),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: labelColor),
                    color: cardBg,
                    onSelected: (action) {
                      if (action == 'edit') {
                        onEdit();
                      } else if (action == 'delete') {
                        onDelete();
                      }
                    },
                    itemBuilder: (ctx) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text(
                          "Edit Patient",
                          style: TextStyle(color: textColor),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          "Delete Patient",
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    Color dotColor = AppColors.success;
    Color bgPillColor = AppColors.success.withValues(alpha: 0.1);
    String label = "Active";

    if (status.toLowerCase().contains("away")) {
      dotColor = AppColors.accent;
      bgPillColor = AppColors.accent.withValues(alpha: 0.1);
      label = "Away";
    } else if (status.toLowerCase().contains("inactive")) {
      dotColor = AppColors.error;
      bgPillColor = AppColors.error.withValues(alpha: 0.1);
      label = "Inactive";
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgPillColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: dotColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              color: dotColor,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
