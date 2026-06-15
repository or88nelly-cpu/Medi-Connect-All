import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/utils/constants/app_assets.dart';

class AppointmentSummaryCard extends StatelessWidget {
  final int totalCount;
  final int completedCount;
  final int pendingCount;
  final int cancelledCount;
  final VoidCallback onViewCalendar;

  const AppointmentSummaryCard({
    super.key,
    required this.totalCount,
    required this.completedCount,
    required this.pendingCount,
    required this.cancelledCount,
    required this.onViewCalendar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F6FFF), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            // Floating 3D Calendar Asset on the right side
            Positioned(
              right: -10.w,
              top: -10.h,
              child: Image.asset(
                AppAssets.calendar3d,
                width: 130.r,
                height: 130.r,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "TODAY'S SCHEDULE",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "$totalCount",
                        style: AppTextStyles.headingMedium.copyWith(
                          color: Colors.white,
                          fontSize: 36.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Appointments",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  // Count row
                  Row(
                    children: [
                      _buildStatItem(
                        icon: Icons.check_circle,
                        count: completedCount,
                        label: "Completed",
                        color: const Color(0xFF34C759),
                      ),
                      Container(
                        height: 24.h,
                        width: 1.w,
                        color: Colors.white24,
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                      ),
                      _buildStatItem(
                        icon: Icons.access_time_filled,
                        count: pendingCount,
                        label: "Pending",
                        color: const Color(0xFFFF9500),
                      ),
                      Container(
                        height: 24.h,
                        width: 1.w,
                        color: Colors.white24,
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                      ),
                      _buildStatItem(
                        icon: Icons.cancel,
                        count: cancelledCount,
                        label: "Cancelled",
                        color: const Color(0xFFFF3B30),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  // View Calendar Button
                  SizedBox(
                    height: 36.h,
                    child: OutlinedButton(
                      onPressed: onViewCalendar,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white60, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "View Calendar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 14.r,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required int count,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 14.r),
        SizedBox(width: 4.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$count",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 8.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
