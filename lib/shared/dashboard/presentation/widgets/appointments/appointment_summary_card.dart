import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/widgets/dynamic_calender_3d.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/constants/app_assets.dart';

class AppointmentSummaryCard extends StatelessWidget {
  final int totalCount;
  final int completedCount;
  final int pendingCount;
  final DateTime date;
  final int cancelledCount;
  final VoidCallback onViewCalendar;

  const AppointmentSummaryCard({
    super.key,
    required this.totalCount,
    required this.completedCount,
    required this.pendingCount,
    required this.cancelledCount,
    required this.onViewCalendar,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 280.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF17153A), Color(0xFF312E81), Color(0xFF5B21B6)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6D5DFB).withAlpha(80),
            blurRadius: 30,
            spreadRadius: 2,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Stack(
          children: [
            // Top Glow
            Positioned(
              right: -50.w,
              top: -40.h,
              child: Container(
                width: 220.r,
                height: 220.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFA855F7).withAlpha(51),
                ),
              ),
            ),

            // Bottom Glow
            Positioned(
              left: -70.w,
              bottom: -70.h,
              child: Container(
                width: 180.r,
                height: 180.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent.withAlpha(25),
                ),
              ),
            ),

            // Calendar PNG
            Positioned(
              right: -5.w,
              top: 0,
              child: DynamicCalendar3D(date: date, size: 120.r),
            ),

            Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getScheduleTitle(date),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10.sp,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: 8.r),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "$totalCount",
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                      SizedBox(width: 8.r),
                      Text(
                        "Appointments",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 32.r),

                  Row(
                    children: [
                      Expanded(
                        child: _glassStat(
                          AppAssets.completed,
                          completedCount,
                          "Completed",
                          const Color(0xFF22C55E),
                        ),
                      ),
                      SizedBox(width: 10.r),
                      Expanded(
                        child: _glassStat(
                          AppAssets.pending,
                          pendingCount,
                          "Pending",
                          const Color(0xFFF59E0B),
                        ),
                      ),
                      SizedBox(width: 10.r),
                      Expanded(
                        child: _glassStat(
                          AppAssets.cancelled,
                          cancelledCount,
                          "Cancelled",
                          const Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.r),

                  GestureDetector(
                    onTap: onViewCalendar,
                    child: Container(
                      height: 35.r,
                      padding: EdgeInsets.symmetric(horizontal: 18.r),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.r),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "View Calendar",
                            style: AppTextStyles.bodySmall.copyWith(
                              color: const Color(0xFF312E81),
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp,
                            ),
                          ),
                          SizedBox(width: 6.r),
                          Icon(
                            Icons.arrow_forward,
                            size: 16.r,
                            color: Color(0xFF312E81),
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

  Widget _glassStat(String icon, int count, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 20.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.white.withAlpha(20),
        border: Border.all(color: Colors.white.withAlpha(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomImageView(
                imagePath: icon,
                height: (label.toLowerCase().contains("pending")) ? 20.r : 25.r,
                width: (label.toLowerCase().contains("pending")) ? 20.r : 25.r,
                // color: color,
              ),
              SizedBox(width: 8.r),
              Text(
                "$count",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white70,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  String getScheduleTitle(DateTime selectedDate) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    final difference = date.difference(today).inDays;

    switch (difference) {
      case 0:
        return "TODAY'S SCHEDULE";
      case 1:
        return "TOMORROW'S SCHEDULE";
      case -1:
        return "YESTERDAY'S SCHEDULE";
      default:
        return "${DateFormat('EEE, dd MMM').format(selectedDate).toUpperCase()} SCHEDULE";
    }
  }
}
