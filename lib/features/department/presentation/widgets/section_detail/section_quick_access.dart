import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/dash_board/presentation/pages/admin/admin_appointments_page.dart';
import 'package:medi_connect/features/dash_board/presentation/pages/admin/admin_patients_page.dart';
import 'package:medi_connect/features/dash_board/presentation/pages/admin/admin_recent_activity_page.dart';
import 'package:medi_connect/features/dash_board/presentation/pages/admin/admin_billing_page.dart';

class SectionQuickAccess extends StatelessWidget {
  const SectionQuickAccess({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;
    final cardBg = isDark
        ? AppColors.terminalDarkCard
        : AppColors.terminalLightCard;
    final cardBorder = isDark
        ? AppColors.terminalDarkBorder
        : AppColors.terminalLightBorder;

    final List<Map<String, dynamic>> items = [
      {
        'label': 'Appointments',
        'icon': Icons.calendar_today_outlined,
        'color': AppColors.primary,
        'page': const AdminAppointmentsPage(),
      },
      {
        'label': 'Patients',
        'icon': Icons.people_outline,
        'color': AppColors.secondary,
        'page': const AdminPatientsPage(),
      },
      {
        'label': 'Analytics',
        'icon': Icons.trending_up_outlined,
        'color': AppColors.accent,
        'page': const AdminRecentActivityPage(),
      },
      {
        'label': 'Reports',
        'icon': Icons.description_outlined,
        'color': AppColors.infoIndigo,
        'page': const AdminBillingPage(),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Department Quick Access",
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.map((item) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => Scaffold(
                          backgroundColor: isDark
                              ? AppColors.terminalDarkBg
                              : AppColors.terminalLightBg,
                          appBar: AppBar(
                            title: Text(item['label']),
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            iconTheme: IconThemeData(color: textColor),
                          ),
                          body: item['page'],
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: cardBorder),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(item['icon'], color: item['color'], size: 24.r),
                        SizedBox(height: 8.h),
                        Text(
                          item['label'],
                          style: AppTextStyles.bodySmall.copyWith(
                            color: textColor,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
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
