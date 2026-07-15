import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

class MrdIntroBanner extends StatelessWidget {
  final bool isDark;

  const MrdIntroBanner({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pending MRD",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : AppColors.textDarkNavy,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  "Monitor and manage medical records pending documentation and approvals",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark ? Colors.white60 : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Icon(Icons.assignment_rounded, color: const Color(0xFF8B5CF6), size: 64.r),
        ],
      ),
    );
  }
}
