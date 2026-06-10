import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/analytics_section.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/management_grid.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/operations_grid.dart';
import 'package:medi_connect/features/department/presentation/pages/department_list_home.dart';
import 'package:medi_connect/features/department/presentation/pages/section_list_home.dart';

class DashboardHomeAdmin extends StatelessWidget {
  const DashboardHomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.r),
      child: Column(
        children: [
          const AnalyticsSection(),
          SectionListHome(),
          SizedBox(height: 24.h),
          DepartmentListHome(),
          SizedBox(height: 24.h),
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
            ),
          ),
          SizedBox(height: 16.h),
          const OperationsGrid(),
        ],
      ),
    );
  }
}
