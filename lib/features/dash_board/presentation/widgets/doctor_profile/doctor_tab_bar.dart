import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';

class DoctorTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const DoctorTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  static const List<Map<String, dynamic>> tabs = [
    {"label": "Overview", "icon": Icons.info_outline},
    {"label": "Schedule & Slots", "icon": Icons.calendar_today_outlined},
    {"label": "Consultations", "icon": Icons.forum_outlined},
    {"label": "Appointments", "icon": Icons.bookmark_added_outlined},
    {"label": "Leaves", "icon": Icons.calendar_month_outlined},
    {"label": "Patients", "icon": Icons.people_outline},
    {"label": "Documents", "icon": Icons.description_outlined},
    {"label": "Analytics", "icon": Icons.analytics_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final activeColor = AppColors.primary;
    final inactiveTextColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;

    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor, width: 1)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (context, idx) {
          final tab = tabs[idx];
          final isSelected = selectedIndex == idx;
          final color = isSelected ? activeColor : inactiveTextColor;

          return InkWell(
            onTap: () => onTabChanged(idx),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? activeColor : Colors.transparent,
                    width: 2.h,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    tab["icon"] as IconData,
                    size: 16.sp,
                    color: color,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    tab["label"] as String,
                    style: TextStyle(
                      color: color,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
