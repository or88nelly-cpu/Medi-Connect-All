import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleHeaderBanner extends StatelessWidget {
  final int totalCount;
  final int completedCount;
  final int pendingCount;
  final int cancelledCount;
  final VoidCallback onViewCalendarTap;
  final bool isDark;

  const ScheduleHeaderBanner({
    super.key,
    required this.totalCount,
    required this.completedCount,
    required this.pendingCount,
    required this.cancelledCount,
    required this.onViewCalendarTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = isDark
        ? const LinearGradient(
            colors: [Color(0xFF1E1B4B), Color(0xFF311042)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFF0F6FFF), Color(0xFF8B5CF6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F6FFF).withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "YESTERDAY'S SCHEDULE",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "$totalCount",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Appointments",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Calendar Jul 5 graphic card representation
              Container(
                width: 55.w,
                height: 62.h,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "JUL",
                      style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "5",
                      style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(child: _buildSubStatCard("Completed", completedCount, const Color(0xFF10B981))),
              SizedBox(width: 8.w),
              Expanded(child: _buildSubStatCard("Pending", pendingCount, const Color(0xFFF59E0B))),
              SizedBox(width: 8.w),
              Expanded(child: _buildSubStatCard("Cancelled", cancelledCount, const Color(0xFFEF4444))),
            ],
          ),
          SizedBox(height: 14.h),
          InkWell(
            onTap: onViewCalendarTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "View Calendar",
                  style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 4.w),
                const Icon(Icons.arrow_forward, color: Colors.white, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubStatCard(String label, int val, Color iconColor) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 14.r,
                height: 14.r,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, size: 8.r, color: iconColor),
              ),
              SizedBox(width: 6.w),
              Text(
                "$val",
                style: TextStyle(color: Colors.black87, fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(color: Colors.grey[500], fontSize: 10.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
