import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class ScheduleDatePickerRow extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onSelectCalendar;
  final VoidCallback onTodayTap;
  final VoidCallback onPrevDay;
  final VoidCallback onNextDay;
  final bool isDark;

  const ScheduleDatePickerRow({
    super.key,
    required this.selectedDate,
    required this.onSelectCalendar,
    required this.onTodayTap,
    required this.onPrevDay,
    required this.onNextDay,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textCol = isDark ? Colors.white : AppColors.textDarkNavy;
    final calendarIconBg = isDark
        ? const Color(0xFF312E81)
        : const Color(0xFFEEF2FF);
    final arrowBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6);

    return Row(
      children: [
        // Calendar button
        InkWell(
          onTap: onSelectCalendar,
          child: Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: calendarIconBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: const Icon(
              Icons.calendar_month,
              color: Color(0xFF8B5CF6),
              size: 20,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        // Date Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('dd MMMM yyyy').format(selectedDate),
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textCol,
                  fontSize: 13.sp,
                ),
              ),
              Text(
                DateFormat('EEEE').format(selectedDate),
                style: TextStyle(color: Colors.grey[500], fontSize: 10.sp),
              ),
            ],
          ),
        ),
        // Today button
        InkWell(
          onTap: onTodayTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.white,
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              "Today",
              style: TextStyle(
                color: const Color(0xFF0F6FFF),
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        // Left Chevron
        InkWell(
          onTap: onPrevDay,
          child: Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: arrowBg,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.chevron_left, color: textCol, size: 18.r),
          ),
        ),
        SizedBox(width: 4.w),
        // Right Chevron
        InkWell(
          onTap: onNextDay,
          child: Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: arrowBg,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.chevron_right, color: textCol, size: 18.r),
          ),
        ),
      ],
    );
  }
}
