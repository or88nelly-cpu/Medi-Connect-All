import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class WorkingHoursCard extends StatelessWidget {
  const WorkingHoursCard({super.key});

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

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Edit button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Working Hours",
                style: AppTextStyles.titleMedium.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Editing working hours timings..."),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      size: 13.sp,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "Edit",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Shift details
          Row(
            children: [
              Expanded(
                child: _buildShiftItem(
                  icon: Icons.wb_twilight_outlined,
                  title: "Morning",
                  time: "09:00 AM - 01:00 PM",
                  iconColor: Colors.amber,
                  labelColor: labelColor,
                  textColor: textColor,
                ),
              ),
              _buildDivider(borderColor),
              Expanded(
                child: _buildShiftItem(
                  icon: Icons.wb_sunny_outlined,
                  title: "Afternoon",
                  time: "02:00 PM - 06:00 PM",
                  iconColor: Colors.orange,
                  labelColor: labelColor,
                  textColor: textColor,
                ),
              ),
              _buildDivider(borderColor),
              Expanded(
                child: _buildShiftItem(
                  icon: Icons.access_time,
                  title: "Slot Duration",
                  time: "10 Minutes",
                  iconColor: const Color(0xFF9C27B0),
                  labelColor: labelColor,
                  textColor: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(Color color) {
    return Container(
      width: 1.w,
      height: 28.h,
      color: color,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
    );
  }

  Widget _buildShiftItem({
    required IconData icon,
    required String title,
    required String time,
    required Color iconColor,
    required Color labelColor,
    required Color textColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 18.sp, color: iconColor),
        SizedBox(width: 6.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(color: labelColor, fontSize: 9.sp),
              ),
              SizedBox(height: 2.h),
              Text(
                time,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 10.sp,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
