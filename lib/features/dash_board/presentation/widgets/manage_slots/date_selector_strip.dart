import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class DateSelectorStrip extends StatefulWidget {
  final String initialDate;
  final ValueChanged<String>? onDateChanged;

  const DateSelectorStrip({
    super.key,
    required this.initialDate,
    this.onDateChanged,
  });

  @override
  State<DateSelectorStrip> createState() => _DateSelectorStripState();
}

class _DateSelectorStripState extends State<DateSelectorStrip> {
  late String _selectedDateDropdown;
  late int _selectedDayIndex;

  final List<Map<String, String>> _weekDays = [
    {"day": "Mon", "date": "19"},
    {"day": "Tue", "date": "20"},
    {"day": "Wed", "date": "21"},
    {"day": "Thu", "date": "22"},
    {"day": "Fri", "date": "23"},
    {"day": "Sat", "date": "24"},
    {"day": "Sun", "date": "25"},
  ];

  @override
  void initState() {
    super.initState();
    _selectedDateDropdown = widget.initialDate;
    _selectedDayIndex = 1; // Default to Tue 20
  }

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
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with dropdown date selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Select Date",
                style: AppTextStyles.titleMedium.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedDateDropdown,
                  dropdownColor: cardBg,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: labelColor,
                    size: 14.sp,
                  ),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedDateDropdown = val;
                      });
                      if (widget.onDateChanged != null) {
                        widget.onDateChanged!(val);
                      }
                    }
                  },
                  items: ["20 May 2025", "21 May 2025", "22 May 2025"].map((
                    date,
                  ) {
                    return DropdownMenuItem<String>(
                      value: date,
                      child: Text(date),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Horizontal calendar strip
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_weekDays.length, (idx) {
              final isSelected = _selectedDayIndex == idx;
              final dayInfo = _weekDays[idx];
              final isWeekend = dayInfo["day"] == "Sun";

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDayIndex = idx;
                    });
                    if (widget.onDateChanged != null) {
                      widget.onDateChanged!("${dayInfo['date']} May 2025");
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? AppColors.primary : borderColor,
                        width: 1.r,
                      ),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          dayInfo["day"]!,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : (isWeekend ? AppColors.error : labelColor),
                            fontSize: 10.sp,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          dayInfo["date"]!,
                          style: TextStyle(
                            color: isSelected ? Colors.white : textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 14.h),
          // Status Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem("Available", const Color(0xFF0F9F58)),
              SizedBox(width: 14.w),
              _buildLegendItem("Booked", AppColors.primary),
              SizedBox(width: 14.w),
              _buildLegendItem("On Hold", AppColors.warning),
              SizedBox(width: 14.w),
              _buildLegendItem("Blocked", AppColors.error),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8.r,
          height: 8.r,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
