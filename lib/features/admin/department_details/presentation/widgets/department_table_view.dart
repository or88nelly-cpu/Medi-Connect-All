import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/features/admin/department_details/presentation/widgets/department_table_row.dart';
import 'package:medi_connect/features/admin/staff_management/domain/entities/department_entity.dart';

/// Table view displaying departments as an enterprise Data Table.
class DepartmentTableView extends StatelessWidget {
  final List<DepartmentEntity> departments;
  final bool isLoading;

  const DepartmentTableView({
    super.key,
    required this.departments,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      decoration: _containerDecoration(isDark),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              isDark
                  ? AppColors.tableHeaderDark
                  : AppColors.terminalLightFieldFill,
            ),
            dataRowMaxHeight: 64.h,
            dividerThickness: 1,
            horizontalMargin: 20.w,
            columnSpacing: 24.w,
            columns: _buildColumns(isDark),
            rows: departments
                .map(
                  (dept) =>
                      DepartmentTableRow.fromEntity(dept: dept, isDark: isDark),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  BoxDecoration _containerDecoration(bool isDark) {
    return BoxDecoration(
      color: isDark ? AppColors.darkCard : Colors.white,
      borderRadius: BorderRadius.circular(20.r),
      border: Border.all(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.05),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  List<DataColumn> _buildColumns(bool isDark) {
    final headers = [
      AppStrings.departmentCode,
      AppStrings.departmentName,
      AppStrings.headOfDepartment,
      AppStrings.status,
      AppStrings.actions,
    ];
    return headers
        .map(
          (h) => DataColumn(
            label: Text(
              h,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textDarkNavy,
              ),
            ),
          ),
        )
        .toList();
  }
}
