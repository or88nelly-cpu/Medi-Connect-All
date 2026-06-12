import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';

class SlotsSummaryRow extends StatelessWidget {
  final int totalSlots;
  final int bookedSlots;
  final int onHoldSlots;
  final int blockedSlots;

  const SlotsSummaryRow({
    super.key,
    required this.totalSlots,
    required this.bookedSlots,
    required this.onHoldSlots,
    required this.blockedSlots,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryItem(
              icon: Icons.calendar_month_outlined,
              label: "Total Slots",
              value: totalSlots.toString(),
              iconColor: const Color(0xFF0F9F58),
              labelColor: labelColor,
              textColor: textColor,
            ),
          ),
          _buildDivider(borderColor),
          Expanded(
            child: _buildSummaryItem(
              icon: Icons.check_box_outlined,
              label: "Booked",
              value: bookedSlots.toString(),
              iconColor: AppColors.primary,
              labelColor: labelColor,
              textColor: textColor,
            ),
          ),
          _buildDivider(borderColor),
          Expanded(
            child: _buildSummaryItem(
              icon: Icons.access_time_outlined,
              label: "On Hold",
              value: onHoldSlots.toString(),
              iconColor: AppColors.warning,
              labelColor: labelColor,
              textColor: textColor,
            ),
          ),
          _buildDivider(borderColor),
          Expanded(
            child: _buildSummaryItem(
              icon: Icons.block_flipped,
              label: "Blocked",
              value: blockedSlots.toString(),
              iconColor: AppColors.error,
              labelColor: labelColor,
              textColor: textColor,
            ),
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
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    required Color labelColor,
    required Color textColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 13.sp,
              color: iconColor,
            ),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                color: labelColor,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}
