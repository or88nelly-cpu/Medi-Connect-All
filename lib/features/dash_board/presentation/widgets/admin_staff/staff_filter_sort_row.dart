import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';

class StaffFilterSortRow extends StatelessWidget {
  const StaffFilterSortRow({
    super.key,
    required this.selectedFilterNotifier,
    required this.sortByNotifier,
    required this.statusFilterNotifier,
    required this.currentPageNotifier,
    required this.categories,
  });

  final ValueNotifier<String> selectedFilterNotifier;
  final ValueNotifier<String> sortByNotifier;
  final ValueNotifier<String> statusFilterNotifier;
  final ValueNotifier<int> currentPageNotifier;
  final List<String> categories;

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

    return Row(
      children: [
        // Categories dropdown
        Expanded(
          flex: 4,
          child: ValueListenableBuilder<String>(
            valueListenable: selectedFilterNotifier,
            builder: (context, selectedFilter, _) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: borderColor, width: 1.2),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: categories.contains(selectedFilter)
                        ? selectedFilter
                        : 'All',
                    icon: Icon(Icons.keyboard_arrow_down, color: labelColor),
                    isExpanded: true,
                    dropdownColor: cardBg,
                    items: categories.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(
                          cat == 'All' ? 'All Categories' : cat,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        selectedFilterNotifier.value = val;
                        currentPageNotifier.value = 1;
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(width: 8.w),

        // Filters Popup Button
        Expanded(
          flex: 3,
          child: ValueListenableBuilder<String>(
            valueListenable: statusFilterNotifier,
            builder: (context, currentFilter, _) {
              return PopupMenuButton<String>(
                color: cardBg,
                onSelected: (val) {
                  statusFilterNotifier.value = val;
                  currentPageNotifier.value = 1;
                },
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    value: 'All',
                    child: Text(
                      'All Statuses',
                      style: TextStyle(color: textColor, fontSize: 12.sp),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'Active',
                    child: Text(
                      'Active Only',
                      style: TextStyle(color: textColor, fontSize: 12.sp),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'Away',
                    child: Text(
                      'Away Only',
                      style: TextStyle(color: textColor, fontSize: 12.sp),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'Inactive',
                    child: Text(
                      'Inactive Only',
                      style: TextStyle(color: textColor, fontSize: 12.sp),
                    ),
                  ),
                ],
                child: _buildFilterSortButton(
                  context,
                  currentFilter == 'All' ? 'Filters' : currentFilter,
                  Icons.tune,
                ),
              );
            },
          ),
        ),
        SizedBox(width: 8.w),

        // Sort Popup Button
        Expanded(
          flex: 3,
          child: ValueListenableBuilder<String>(
            valueListenable: sortByNotifier,
            builder: (context, currentSort, _) {
              return PopupMenuButton<String>(
                color: cardBg,
                onSelected: (val) {
                  sortByNotifier.value = val;
                  currentPageNotifier.value = 1;
                },
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    value: 'Name (A-Z)',
                    child: Text(
                      'Name (A-Z)',
                      style: TextStyle(color: textColor, fontSize: 12.sp),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'Name (Z-A)',
                    child: Text(
                      'Name (Z-A)',
                      style: TextStyle(color: textColor, fontSize: 12.sp),
                    ),
                  ),
                ],
                child: _buildFilterSortButton(
                  context,
                  currentSort == 'None' ? 'Sort' : currentSort,
                  Icons.swap_vert,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSortButton(
    BuildContext context,
    String label,
    IconData icon,
  ) {
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
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: labelColor, size: 16.r),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
