import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/functions/profile_image_helper.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';

class ManageSlotsDoctorCard extends StatelessWidget {
  final UserModel user;
  const ManageSlotsDoctorCard({super.key, required this.user});

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

    final imgPath = ProfileImageHelper.resolveImagePath(
      user.profilePhoto,
      user.role,
      user.gender,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          // Doctor Image with status dot
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 50.r,
                height: 50.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 1.5.r,
                  ),
                ),
                child: CustomImageView(imagePath: imgPath, borderRadius: 25.r),
              ),
              Positioned(
                bottom: 2.h,
                right: 2.w,
                child: Container(
                  width: 10.r,
                  height: 10.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F9F58),
                    shape: BoxShape.circle,
                    border: Border.all(color: cardBg, width: 1.5.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 12.w),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        user.name ??
                            "${user.firstName ?? ''} ${user.lastName ?? ''}"
                                .trim(),
                        style: AppTextStyles.titleMedium.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.verified, color: AppColors.primary, size: 13.sp),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  user.specialization ?? "Consultant Cardiologist",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Icon(
                      Icons.local_hospital_outlined,
                      size: 10.sp,
                      color: labelColor,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      user.department ?? "Cardiology Department",
                      style: TextStyle(color: labelColor, fontSize: 10.sp),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "EMP ID: ${user.employeeId ?? 'DOC1001'}",
                      style: TextStyle(color: labelColor, fontSize: 10.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          // Arrow right
          Icon(Icons.chevron_right, color: labelColor, size: 20.sp),
        ],
      ),
    );
  }
}
