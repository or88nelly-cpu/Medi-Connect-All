import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

class PatientDateCard extends StatelessWidget {
  const PatientDateCard({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayNames = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    final monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final dayName = dayNames[now.weekday % 7];
    final monthName = monthNames[now.month - 1];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.dashboardCardBg(context),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border(context)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(
              alpha: 0.10,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.calendar_month_rounded,
            color: AppColors.primary,
            size: 22.r,
          ),
          SizedBox(height: 4.h),
          Text(
            '${now.day}',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.dashboardTextPrimary(context),
              height: 1.1,
            ),
          ),
          Text(
            '$monthName ${now.year}',
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textSecondary(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            height: 2.h,
            width: 24.w,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            dayName,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
