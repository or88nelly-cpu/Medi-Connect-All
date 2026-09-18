import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class VisitDatePickerRow extends StatelessWidget {
  final DateTime date;
  final VoidCallback onPreviousPressed;
  final VoidCallback onNextPressed;

  const VisitDatePickerRow({
    super.key,
    required this.date,
    required this.onPreviousPressed,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? Color(0xFF1E293B) : Colors.white;
    final primaryTextColor = isDark ? Colors.white : AppColors.textDarkNavy;
    final borderCol = AppColors.border(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderCol),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: onPreviousPressed,
            icon: Icon(Icons.chevron_left, size: 18),
            label: Text('Previous'),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          ),
          Row(
            children: [
              Text(
                DateFormat('dd MMM yyyy').format(date),
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              SizedBox(width: 6.w),
              Icon(Icons.calendar_month, size: 18, color: AppColors.primary),
            ],
          ),
          TextButton.icon(
            onPressed: onNextPressed,
            icon: Text('Next'),
            label: Icon(Icons.chevron_right, size: 18),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
