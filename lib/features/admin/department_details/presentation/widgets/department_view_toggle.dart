import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

enum DepartmentViewMode { grid, table }

/// Custom view switcher toggle between Grid View and Table View.
class DepartmentViewToggle extends StatelessWidget {
  final DepartmentViewMode currentMode;
  final ValueChanged<DepartmentViewMode> onChanged;

  const DepartmentViewToggle({
    super.key,
    required this.currentMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildOption(
            context,
            mode: DepartmentViewMode.grid,
            label: AppStrings.gridView,
            icon: Icons.grid_view_rounded,
            isSelected: currentMode == DepartmentViewMode.grid,
          ),
          SizedBox(width: 4.w),
          _buildOption(
            context,
            mode: DepartmentViewMode.table,
            label: AppStrings.tableView,
            icon: Icons.table_chart_rounded,
            isSelected: currentMode == DepartmentViewMode.table,
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required DepartmentViewMode mode,
    required String label,
    required IconData icon,
    required bool isSelected,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => onChanged(mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.controlCenterBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(9.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.controlCenterBlue.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16.r,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white60 : Colors.grey.shade700),
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 12.sp,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white70 : Colors.grey.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
