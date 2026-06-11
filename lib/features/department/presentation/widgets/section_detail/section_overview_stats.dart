import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class SectionOverviewStats extends StatelessWidget {
  final String departmentName;
  final int activeDoctors;
  final int activeStaff;
  final int doctorsOnLeave;
  final int staffOnLeave;

  const SectionOverviewStats({
    super.key,
    required this.departmentName,
    required this.activeDoctors,
    required this.activeStaff,
    required this.doctorsOnLeave,
    required this.staffOnLeave,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final cardBorder = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;

    // Generate stable mock stats based on department name hash to look realistic
    final hash = departmentName.hashCode.abs();
    final patientsToday = hash % 80 + 35;
    final patientsChange = hash % 15 + 6;
    final appointmentsToday = hash % 40 + 15;
    final appointmentsChange = hash % 12 + 4;

    final List<Map<String, dynamic>> stats = [
      {
        'title': 'Patients Today',
        'value': '$patientsToday',
        'subText': '↑$patientsChange% vs yesterday',
        'subColor': AppColors.success,
        'icon': Icons.people_outline,
        'iconColor': AppColors.primary,
      },
      {
        'title': 'Appointments',
        'value': '$appointmentsToday',
        'subText': '↑$appointmentsChange% vs yesterday',
        'subColor': AppColors.success,
        'icon': Icons.calendar_today_outlined,
        'iconColor': AppColors.infoIndigo,
      },
      {
        'title': 'Doctors Available',
        'value': '$activeDoctors',
        'subText': doctorsOnLeave > 0 ? '$doctorsOnLeave on leave' : 'All available',
        'subColor': doctorsOnLeave > 0 ? AppColors.warning : AppColors.secondary,
        'icon': Icons.local_hospital_outlined,
        'iconColor': AppColors.secondary,
      },
      {
        'title': 'Staff Available',
        'value': '$activeStaff',
        'subText': staffOnLeave > 0 ? '$staffOnLeave on leave' : 'All available',
        'subColor': staffOnLeave > 0 ? AppColors.warning : AppColors.accent,
        'icon': Icons.badge_outlined,
        'iconColor': AppColors.accent,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Overview",
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: stats.map((stat) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            stat['icon'],
                            color: stat['iconColor'],
                            size: 16.r,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              stat['title'],
                              style: TextStyle(
                                color: labelColor,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        stat['value'],
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        stat['subText'],
                        style: TextStyle(
                          color: stat['subColor'],
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
