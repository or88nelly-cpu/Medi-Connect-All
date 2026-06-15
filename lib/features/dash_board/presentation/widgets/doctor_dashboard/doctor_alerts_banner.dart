import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';

class DoctorAlertsBanner extends StatelessWidget {
  const DoctorAlertsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1B1B) : const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? const Color(0xFF3B1E1E) : const Color(0xFFFEE2E2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Red alert bell icon
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFFE11D48).withValues(alpha: 0.2)
                  : const Color(0xFFFEE2E2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_active_outlined,
              color: Color(0xFFE11D48),
              size: 20,
            ),
          ),
          SizedBox(width: 12.w),
          // Alert text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Important Alerts",
                  style: TextStyle(
                    color: const Color(0xFFE11D48),
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "You have 2 pending lab reports to review",
                  style: TextStyle(
                    color: isDark ? Colors.white70 : AppColors.textSecondary,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
          // View Now link
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Redirecting to pending lab reports..."),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
              child: Row(
                children: [
                  Text(
                    "View Now",
                    style: TextStyle(
                      color: const Color(0xFFE11D48),
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFFE11D48),
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
