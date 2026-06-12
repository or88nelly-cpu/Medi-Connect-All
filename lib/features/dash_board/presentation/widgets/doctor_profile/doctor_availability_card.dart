import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class DoctorAvailabilityCard extends StatefulWidget {
  final String initialStatus;
  final ValueChanged<String>? onStatusChanged;

  const DoctorAvailabilityCard({
    super.key,
    required this.initialStatus,
    this.onStatusChanged,
  });

  @override
  State<DoctorAvailabilityCard> createState() => _DoctorAvailabilityCardState();
}

class _DoctorAvailabilityCardState extends State<DoctorAvailabilityCard> {
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.initialStatus;
  }

  final List<Map<String, dynamic>> _statusOptions = [
    {
      "name": "Online",
      "icon": Icons.circle,
      "color": const Color(0xFF0F9F58),
      "desc": "Available for Appointments"
    },
    {
      "name": "Busy",
      "icon": Icons.error_outline,
      "color": AppColors.warning,
      "desc": "In consultations / surgeries"
    },
    {
      "name": "Offline",
      "icon": Icons.remove_circle_outline,
      "color": AppColors.error,
      "desc": "Not currently active"
    },
    {
      "name": "On Leave",
      "icon": Icons.calendar_today_outlined,
      "color": AppColors.primary,
      "desc": "Out of clinic today"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;

    final activeStatusDetail = _statusOptions.firstWhere(
      (s) => s["name"].toString().toLowerCase() == _currentStatus.toLowerCase(),
      orElse: () => _statusOptions.first,
    );

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Availability Status",
                style: AppTextStyles.titleMedium.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: (activeStatusDetail["color"] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: activeStatusDetail["color"] as Color,
                    width: 0.5,
                  ),
                ),
                child: Text(
                  activeStatusDetail["name"] as String,
                  style: TextStyle(
                    color: activeStatusDetail["color"] as Color,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            "Currently ${activeStatusDetail["desc"]}",
            style: TextStyle(
              color: labelColor,
              fontSize: 11.sp,
            ),
          ),
          SizedBox(height: 16.h),
          // Option Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _statusOptions.map((opt) {
              final optName = opt["name"] as String;
              final isSelected = optName.toLowerCase() == _currentStatus.toLowerCase();
              final optColor = opt["color"] as Color;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentStatus = optName;
                    });
                    if (widget.onStatusChanged != null) {
                      widget.onStatusChanged!(optName);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? optColor.withOpacity(0.1)
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? optColor
                            : borderColor,
                        width: 1.r,
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          opt["icon"] as IconData,
                          size: 16.sp,
                          color: isSelected ? optColor : labelColor,
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          optName,
                          style: TextStyle(
                            color: isSelected ? optColor : textColor,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
