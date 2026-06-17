import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';

class DoctorStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final String badgeText;
  final Color themeColor;

  const DoctorStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.badgeText,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      //   width: 105.w,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.terminalDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isDark
              ? themeColor.withValues(alpha: 0.3)
              : themeColor.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: themeColor.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Container
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: themeColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: themeColor, size: 16.r),
          ),
          SizedBox(height: 4.h),
          // Value
          Text(
            value,
            style: TextStyle(
              color: themeColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Label
          Text(
            label,
            style: TextStyle(
              color: isDark ? Colors.white70 : AppColors.textSecondary(context),
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          // Badge
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
          //   decoration: BoxDecoration(
          //     color: themeColor.withValues(alpha: 0.1),
          //     borderRadius: BorderRadius.circular(12.r),
          //   ),
          //   child: Text(
          //     badgeText,
          //     style: TextStyle(
          //       color: themeColor,
          //       fontSize: 8.sp,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
