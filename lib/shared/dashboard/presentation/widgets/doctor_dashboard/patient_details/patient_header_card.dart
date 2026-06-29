import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/constants/app_assets.dart';
import 'package:medi_connect/shared/auth/domain/entities/user_entity.dart';

class PatientHeaderCard extends StatelessWidget {
  final UserEntity patient;

  const PatientHeaderCard({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final displayName =
        patient.name ??
        "${patient.firstName ?? ''} ${patient.lastName ?? ''}".trim();
    final gender = patient.gender ?? "Not Specified";
    final ageStr = patient.age != null ? "${patient.age} years" : "N/A";
    final bloodGroup = patient.bloodGroup ?? "N/A";
    final allergies = patient.allergies ?? "None reported";

    final defaultAvatar = gender.toLowerCase() == 'female'
        ? AppAssets.femaleAvatarPng
        : AppAssets.maleAvatarPng;

    final borderCol = AppColors.border(context);

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
              : [const Color(0xFFE8F1FF), const Color(0xFFF3F7FD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderCol),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circular Avatar
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 34.r,
              backgroundColor: isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFE2E8F0),
              backgroundImage:
                  patient.profilePhoto != null &&
                      patient.profilePhoto!.isNotEmpty
                  ? NetworkImage(patient.profilePhoto!) as ImageProvider
                  : AssetImage(defaultAvatar),
            ),
          ),
          SizedBox(width: 14.w),

          // Details Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  displayName,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textDarkNavy,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  "${AppStrings.agePrefix}$ageStr  •  ${AppStrings.genderPrefix}$gender",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark
                        ? Colors.white70
                        : AppColors.textSecondary(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 6.w,
                  runSpacing: 4.h,
                  children: [
                    // Blood tag
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        "${AppStrings.bloodPrefix}$bloodGroup",
                        style: TextStyle(
                          color: const Color(0xFFEF4444),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Allergies tag
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        "${AppStrings.allergiesPrefix}$allergies",
                        style: TextStyle(
                          color: const Color(0xFFD97706),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Right-aligned 3D illustration
          SizedBox(width: 10.w),
          Image.asset(
            AppAssets.appointments,
            height: 70.h,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
