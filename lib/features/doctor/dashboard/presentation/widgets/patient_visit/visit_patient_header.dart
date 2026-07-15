import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/functions/date_utils.dart';
import 'package:medi_connect/core/functions/profile_image_helper.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/features/authentication/domain/entities/user_entity.dart';

class VisitPatientHeader extends StatelessWidget {
  final UserEntity patient;
  final String token;

  const VisitPatientHeader({
    super.key,
    required this.patient,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    final ageStr = AppDateUtils.calculateAge(patient.dob) ?? '30';
    final uhidStr = patient.id.length > 8
        ? patient.id.substring(0, 8).toUpperCase()
        : '2025000123';

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 36.r,
                backgroundColor: Colors.white24,
                backgroundImage: ProfileImageHelper.getAvatarImage(
                  patient.profilePhoto,
                  'patient',
                  patient.gender,
                ),
              ),
              Container(
                padding: EdgeInsets.all(4.r),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF0F6FFF),
                ),
                child: Icon(Icons.camera_alt, size: 12.r, color: Colors.white),
              ),
            ],
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      patient.fullName,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      patient.gender?.toLowerCase() == 'female'
                          ? Icons.female
                          : Icons.male,
                      color: Colors.white70,
                      size: 16.r,
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        '$ageStr Y',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      patient.gender ?? 'Male',
                      style: TextStyle(color: Colors.white70, fontSize: 11.sp),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'UHID: $uhidStr',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Text(
                      'OPD/$token',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Icon(Icons.phone, size: 12.r, color: Colors.white70),
                    SizedBox(width: 4.w),
                    Text(
                      patient.phone ?? '+91 98765 43210',
                      style: TextStyle(color: Colors.white70, fontSize: 11.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
