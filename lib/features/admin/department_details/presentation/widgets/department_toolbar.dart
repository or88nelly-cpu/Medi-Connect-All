import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/features/admin/department_details/presentation/widgets/department_view_toggle.dart';

/// Toolbar row: search input | Grid/Table toggle | Filter button.
class DepartmentToolbar extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final DepartmentViewMode viewMode;
  final ValueChanged<DepartmentViewMode> onViewModeChanged;

  const DepartmentToolbar({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.viewMode,
    required this.onViewModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        // Search
        Expanded(
          child: Container(
            height: 44.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.black.withValues(alpha: isDark ? 0.0 : 0.07),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  size: 17.r,
                  color: Colors.grey.shade400,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: isDark ? Colors.white : AppColors.textDarkNavy,
                    ),
                    decoration: InputDecoration(
                      hintText: AppStrings.departmentSearchPlaceholder,
                      hintStyle: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey.shade400,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        // Grid/Table toggle
        DepartmentViewToggle(
          currentMode: viewMode,
          onChanged: onViewModeChanged,
        ),
        SizedBox(width: 10.w),
        // Filter button
        _FilterButton(isDark: isDark),
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  final bool isDark;
  const _FilterButton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.black.withValues(alpha: isDark ? 0.0 : 0.07),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.filter_list_rounded,
            size: 16.r,
            color: isDark ? Colors.white70 : Colors.grey.shade700,
          ),
          SizedBox(width: 6.w),
          Text(
            'Filter',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
            ),
          ),
          SizedBox(width: 4.w),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 16.r,
            color: Colors.grey.shade500,
          ),
        ],
      ),
    );
  }
}
