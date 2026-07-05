import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/domain/entities/user_entity.dart';

class DoctorHeader extends StatelessWidget {
  final UserEntity doctor;
  final Widget datePickerPill;
  final VoidCallback onMenuTap;
  final VoidCallback onSearchTap;
  final VoidCallback onNotificationsTap;

  const DoctorHeader({
    super.key,
    required this.doctor,
    required this.datePickerPill,
    required this.onMenuTap,
    required this.onSearchTap,
    required this.onNotificationsTap,
  });

  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning,";
    } else if (hour < 17) {
      return "Good Afternoon,";
    } else {
      return "Good Evening,";
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final greeting = _getTimeGreeting();
    final displayName =
        doctor.fullName.startsWith(
          RegExp(r'^(dr\.|dr|Dr\.|Dr)\s+', caseSensitive: false),
        )
        ? doctor.fullName
        : "Dr. ${doctor.fullName}";

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
              : [const Color(0xFFE0F2FE), const Color(0xFFF8FAFC)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background stethoscope hero artwork
          Positioned(
            right: -20.w,
            top: 20.h,
            child: Opacity(
              opacity: isDark ? 0.4 : 0.85,
              child: Image.asset(
                'assets/images/doctor_dashboard_hero.png',
                width: 250.r,
                height: 250.r,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Content
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome text
                  Text(
                    greeting,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDark ? Colors.white60 : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Text(
                        displayName,
                        style: AppTextStyles.headingMedium.copyWith(
                          color: isDark ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 26.sp,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Icon(
                        Icons.verified_rounded,
                        color: const Color(0xFF0F6FFF),
                        size: 18.r,
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    "Here's your overview for today",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDark ? Colors.white38 : Colors.grey[500],
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Date Picker Pill
                  datePickerPill,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
