import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class SlotStatusCard extends StatefulWidget {
  final ValueChanged<String>? onStatusChanged;

  const SlotStatusCard({super.key, this.onStatusChanged});

  @override
  State<SlotStatusCard> createState() => _SlotStatusCardState();
}

class _SlotStatusCardState extends State<SlotStatusCard> {
  String _selectedStatus = "Available";

  final List<Map<String, dynamic>> _statuses = [
    {"name": "Available", "color": const Color(0xFF0F9F58)},
    {"name": "Booked", "color": AppColors.primary},
    {"name": "On Hold", "color": AppColors.warning},
    {"name": "Blocked", "color": AppColors.error},
  ];

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
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Slot Status",
            style: AppTextStyles.titleMedium.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            "Select initial status for the slot",
            style: TextStyle(color: labelColor, fontSize: 10.sp),
          ),
          SizedBox(height: 14.h),
          // Horizontal status options row
          Row(
            children: _statuses.map((item) {
              final name = item["name"] as String;
              final isSelected = name == _selectedStatus;
              final color = item["color"] as Color;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedStatus = name;
                    });
                    if (widget.onStatusChanged != null) {
                      widget.onStatusChanged!(name);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withValues(alpha: 0.1)
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? color : borderColor,
                        width: 1.r,
                      ),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 8.r,
                          height: 8.r,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          name,
                          style: TextStyle(
                            color: isSelected ? color : textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
