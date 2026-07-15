import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class MrdDateSwitcher extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onPrevPressed;
  final VoidCallback onNextPressed;
  final bool isDark;

  const MrdDateSwitcher({
    super.key,
    required this.selectedDate,
    required this.onPrevPressed,
    required this.onNextPressed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final bannerBg = isDark
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
        gradient: bannerBg,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F6FFF).withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "TODAY'S DATE",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                DateFormat('MMM dd, yyyy').format(selectedDate),
                style: AppTextStyles.titleLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              Text(
                DateFormat('EEEE').format(selectedDate),
                style: TextStyle(color: Colors.white60, fontSize: 11.sp),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white),
                onPressed: onPrevPressed,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      DateFormat('MMM dd, yyyy').format(selectedDate),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white),
                onPressed: onNextPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
