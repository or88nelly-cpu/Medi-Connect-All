import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/constants/app_assets.dart';
import 'package:medi_connect/core/functions/profile_image_helper.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';

// --- OPERATIONS MODULE HEADER ---
class EmrdDashboardHeader extends StatelessWidget {
  final String name;
  final String role;
  final String? profileImage;
  final String? gender;
  final Map<String, dynamic> stats;
  final bool isDark;
  final VoidCallback onBack;

  const EmrdDashboardHeader({
    super.key,
    required this.name,
    required this.role,
    required this.profileImage,
    required this.gender,
    required this.stats,
    required this.isDark,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final alertCount = stats['active_alerts'] ?? 5;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark 
              ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
              : [const Color(0xFFE0F2FE), const Color(0xFFF0F9FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
      ),
      child: Stack(
        children: [
          // ECG heartbeat background line
          Positioned(
            bottom: 40.h,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 60.h,
              child: CustomPaint(
                painter: ECGPainter(
                  color: isDark 
                      ? Colors.white.withOpacity(0.04) 
                      : AppColors.primary.withOpacity(0.08),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: onBack,
                      borderRadius: BorderRadius.circular(30.r),
                      child: Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          size: 20.r,
                          color: isDark ? Colors.white : AppColors.textPrimary(context),
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Operations",
                            style: AppTextStyles.headingMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 22.sp,
                              color: isDark ? Colors.white : AppColors.textPrimary(context),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "Manage daily medical record operations",
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 11.sp,
                              color: isDark ? Colors.white54 : AppColors.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Notification Bell
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.r),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white10 : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.notifications_none_outlined,
                            size: 22.r,
                            color: isDark ? Colors.white : AppColors.textPrimary(context),
                          ),
                        ),
                        if (alertCount > 0)
                          Positioned(
                            top: -2.h,
                            right: -2.w,
                            child: Container(
                              padding: EdgeInsets.all(4.r),
                              decoration: const BoxDecoration(
                                color: Color(0xFFDC2626),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                "$alertCount",
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(width: 10.w),
                    // Profile Image
                    Stack(
                      children: [
                        Container(
                          width: 42.r,
                          height: 42.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? Colors.white24 : AppColors.primary,
                              width: 1.5,
                            ),
                          ),
                          child: CustomImageView(
                            imagePath: ProfileImageHelper.resolveImagePath(
                              profileImage,
                              role,
                              gender,
                            ),
                            borderRadius: 21.r,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 12.r,
                            height: 12.r,
                            decoration: BoxDecoration(
                              color: const Color(0xFF22C55E),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                
                // Hospital banner overlapping/glassmorphism
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isDark ? Colors.white10 : Colors.white,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                "Aster MIMS Center",
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "Department of Health Records",
                              style: AppTextStyles.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                                color: isDark ? Colors.white : AppColors.textPrimary(context),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "System is online. All records are fully encrypted and HIPAA compliant.",
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 10.sp,
                                color: isDark ? Colors.white54 : AppColors.textSecondary(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.asset(
                          AppAssets.hospitalPng,
                          width: 80.w,
                          height: 70.h,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 80.w,
                            height: 70.h,
                            color: AppColors.primary.withOpacity(0.1),
                            child: Icon(
                              Icons.local_hospital_outlined,
                              color: AppColors.primary,
                              size: 32.r,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ECGPainter extends CustomPainter {
  final Color color;
  const ECGPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final h = size.height;
    final w = size.width;

    path.moveTo(0, h * 0.5);
    path.lineTo(w * 0.2, h * 0.5);
    path.lineTo(w * 0.23, h * 0.45);
    path.lineTo(w * 0.26, h * 0.55);
    path.lineTo(w * 0.29, h * 0.5);
    path.lineTo(w * 0.45, h * 0.5);
    path.lineTo(w * 0.48, h * 0.65);
    path.lineTo(w * 0.52, h * 0.15);
    path.lineTo(w * 0.56, h * 0.85);
    path.lineTo(w * 0.6, h * 0.5);
    path.lineTo(w * 0.65, h * 0.4);
    path.lineTo(w * 0.7, h * 0.5);
    path.lineTo(w, h * 0.5);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
