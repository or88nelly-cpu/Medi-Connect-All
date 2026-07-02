import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class DoctorDatePickerPill extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const DoctorDatePickerPill({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isToday = DateUtils.isSameDay(selectedDate, DateTime.now());
    
    final formattedDate = DateFormat('dd MMM yyyy, EEEE').format(selectedDate);

    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (context, child) {
            return Theme(
              data: isDark
                  ? ThemeData.dark().copyWith(
                      colorScheme: const ColorScheme.dark(
                        primary: Color(0xFF0F6FFF),
                        onPrimary: Colors.white,
                        surface: Color(0xFF1E293B),
                        onSurface: Colors.white,
                      ),
                    )
                  : ThemeData.light().copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color(0xFF0F6FFF),
                        onPrimary: Colors.white,
                        surface: Colors.white,
                        onSurface: Colors.black,
                      ),
                    ),
              child: child!,
            );
          },
        );
        if (picked != null && picked != selectedDate) {
          onDateChanged(picked);
        }
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: const Color(0xFF0F6FFF).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_today_outlined,
                color: const Color(0xFF0F6FFF),
                size: 16.r,
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isToday ? "Today" : "Selected Date",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark ? Colors.white38 : Colors.grey[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  formattedDate,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            SizedBox(width: 16.w),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: isDark ? Colors.white60 : Colors.grey[600],
              size: 18.r,
            ),
          ],
        ),
      ),
    );
  }
}
