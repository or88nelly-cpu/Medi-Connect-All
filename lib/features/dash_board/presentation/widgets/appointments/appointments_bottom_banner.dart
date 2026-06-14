import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/common_widgets/buttons/gradient_button.dart';

class AppointmentsBottomBanner extends StatelessWidget {
  final VoidCallback onBookNew;

  const AppointmentsBottomBanner({super.key, required this.onBookNew});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2D4A) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? const Color(0xFF2E3E5C) : const Color(0xFFDBEAFE),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Clipboard or Calendar Icon
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: isDark ? Colors.blue.withOpacity(0.1) : Colors.white,
              shape: BoxShape.circle,
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Icon(
              Icons.calendar_month_outlined,
              color: Colors.blue[600],
              size: 26.r,
            ),
          ),
          SizedBox(width: 14.w),
          // Text block
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Stay Organized, Deliver Better Care",
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "Quickly book, manage, and track all patient appointments in one place.",
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 10.sp,
                    color: isDark ? Colors.white54 : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          // Book Button
          GradientButton(
            text: "Book New Appointment",
            onPressed: onBookNew,
            width: 170.w,
            height: 40.h,
            borderRadius: 8.r,
            textStyle: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
