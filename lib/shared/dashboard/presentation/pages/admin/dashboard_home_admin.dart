import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/analytics_section.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/operations_grid.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/pages/department_list_home.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/pages/section_list_home.dart';

class DashboardHomeAdmin extends StatelessWidget {
  const DashboardHomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AnalyticsSection(),
          SectionListHome(),
          SizedBox(height: 8.r),
          DepartmentListHome(),
          SizedBox(height: 8.r),
          // Text(
          //   AppStrings.managementConsole,
          //   style: AppTextStyles.titleMedium.copyWith(
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          // SizedBox(height: 16.h),
          // const ManagementGrid(),
          // SizedBox(height: 24.h),
          Text(
            AppStrings.systemOperations,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.terminalDarkText
                  : AppColors.terminalLightText,
            ),
          ),
          SizedBox(height: 16.h),
          const OperationsGrid(),
        ],
      ),
    );
  }
}
