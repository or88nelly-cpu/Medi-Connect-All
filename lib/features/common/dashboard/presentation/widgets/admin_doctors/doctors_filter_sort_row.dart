import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

class DoctorsFilterSortRow extends StatelessWidget {
  const DoctorsFilterSortRow({
    super.key,
    required this.selectedSectionNotifier,
    required this.sortByNotifier,
    required this.statusFilterNotifier,
    required this.currentPageNotifier,
    required this.sections,
  });

  final ValueNotifier<String> selectedSectionNotifier;
  final ValueNotifier<String> sortByNotifier;
  final ValueNotifier<String> statusFilterNotifier;
  final ValueNotifier<int> currentPageNotifier;
  final List<String> sections;

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
        // Category Dropdown
        Expanded(
          flex: 4,
          child: ValueListenableBuilder<String>(
            valueListenable: selectedSectionNotifier,
            builder: (context, selectedSection, _) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: borderColor, width: 1.2),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: sections.contains(selectedSection)
                        ? selectedSection
                        : 'All',
                    icon: Icon(Icons.keyboard_arrow_down, color: labelColor),
                    isExpanded: true,
                    dropdownColor: cardBg,
                    items: sections.map((sec) {
                      return DropdownMenuItem(
                        value: sec,
                        child: Text(
                          sec == 'All' ? 'All Categories' : sec,
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
                        selectedSectionNotifier.value = val;
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
                  PopupMenuItem(
                    value: 'Experience (High-Low)',
                    child: Text(
                      'Experience (High-Low)',
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
