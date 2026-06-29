import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_assets.dart';
import 'package:medi_connect/core/functions/profile_image_helper.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';

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
              : [
                  const Color(0xFFDCEBFF),
                  const Color(0xFFF1F6FF),
                  Colors.white,
                ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28.r)),
      ),
      child: Stack(
        children: [
          // Background hospital building image on the right ( mock design )
          Positioned(
            right: -10.w,
            bottom: 0,
            child: Opacity(
              opacity: isDark ? 0.08 : 0.22,
              child: Image.asset(
                AppAssets.hospitalPng,
                width: 170.w,
                height: 120.h,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox(),
              ),
            ),
          ),
          // Subtle ECG waveform path
          Positioned(
            bottom: 30.h,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 50.h,
              child: CustomPaint(
                painter: ECGPainter(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.03)
                      : AppColors.primary.withValues(alpha: 0.07),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 32.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Premium round back button
                    InkWell(
                      onTap: onBack,
                      borderRadius: BorderRadius.circular(30.r),
                      child: Container(
                        padding: EdgeInsets.all(9.r),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? Colors.white24
                                : AppColors.primary.withValues(alpha: 0.15),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16.r,
                          color: isDark ? Colors.white : AppColors.primary,
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
                            style: TextStyle(
                              fontSize: 21.sp,
                              fontWeight: FontWeight.w900,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1E293B),
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            "Manage daily medical record operations",
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? Colors.white54
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Notification Bell Icon with Badge
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: EdgeInsets.all(9.r),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white10 : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? Colors.white10
                                  : Colors.grey[100]!,
                            ),
                          ),
                          child: Icon(
                            Icons.notifications_outlined,
                            size: 21.r,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF475569),
                          ),
                        ),
                        if (alertCount > 0)
                          Positioned(
                            top: -2.h,
                            right: -2.w,
                            child: Container(
                              padding: EdgeInsets.all(4.r),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFF1E293B)
                                      : Colors.white,
                                  width: 1.5,
                                ),
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
                          width: 38.r,
                          height: 38.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? Colors.white24 : Colors.white,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: CustomImageView(
                            imagePath: ProfileImageHelper.resolveImagePath(
                              profileImage,
                              role,
                              gender,
                            ),
                            borderRadius: 19.r,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 10.r,
                            height: 10.r,
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                    : Colors.white,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
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

class ECGPainter extends CustomPainter {
  final Color color;
  const ECGPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final h = size.height;
    final w = size.width;

    path.moveTo(0, h * 0.5);
    path.lineTo(w * 0.25, h * 0.5);
    path.lineTo(w * 0.28, h * 0.43);
    path.lineTo(w * 0.31, h * 0.57);
    path.lineTo(w * 0.34, h * 0.5);
    path.lineTo(w * 0.5, h * 0.5);
    path.lineTo(w * 0.53, h * 0.65);
    path.lineTo(w * 0.57, h * 0.15);
    path.lineTo(w * 0.61, h * 0.85);
    path.lineTo(w * 0.65, h * 0.5);
    path.lineTo(w * 0.7, h * 0.4);
    path.lineTo(w * 0.74, h * 0.5);
    path.lineTo(w, h * 0.5);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
