import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class SectionFilterSortRow extends StatelessWidget {
  final ValueNotifier<String> sortByNotifier;
  final ValueNotifier<String> statusFilterNotifier;
  final ValueNotifier<bool> isListViewNotifier;
  final ValueNotifier<int> currentPageNotifier;
  final bool isDoctor;

  const SectionFilterSortRow({
    super.key,
    required this.sortByNotifier,
    required this.statusFilterNotifier,
    required this.isListViewNotifier,
    required this.currentPageNotifier,
    required this.isDoctor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;

    final statuses = ['All', 'Active', 'Away', 'Inactive'];
    final docSortOptions = ['None', 'Name (A-Z)', 'Name (Z-A)', 'Experience (High-Low)'];
    final staffSortOptions = ['None', 'Name (A-Z)', 'Name (Z-A)'];
    final sortOptions = isDoctor ? docSortOptions : staffSortOptions;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Filters Button
            PopupMenuButton<String>(
              onSelected: (val) {
                statusFilterNotifier.value = val;
                currentPageNotifier.value = 1;
              },
              color: cardBg,
              itemBuilder: (ctx) => statuses.map((status) {
                final isSelected = statusFilterNotifier.value == status;
                return PopupMenuItem<String>(
                  value: status,
                  child: Row(
                    children: [
                      if (isSelected)
                        Icon(Icons.check, color: AppColors.primary, size: 16.r)
                      else
                        SizedBox(width: 16.r),
                      SizedBox(width: 8.w),
                      Text(
                        status == 'All' ? 'All Statuses' : status,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    Icon(Icons.tune, color: labelColor, size: 16.r),
                    SizedBox(width: 8.w),
                    ValueListenableBuilder<String>(
                      valueListenable: statusFilterNotifier,
                      builder: (context, filter, _) {
                        return Text(
                          filter == 'All' ? "Filters" : "Status: $filter",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10.w),
            // Sort Button
            PopupMenuButton<String>(
              onSelected: (val) {
                sortByNotifier.value = val;
                currentPageNotifier.value = 1;
              },
              color: cardBg,
              itemBuilder: (ctx) => sortOptions.map((opt) {
                final isSelected = sortByNotifier.value == opt;
                return PopupMenuItem<String>(
                  value: opt,
                  child: Row(
                    children: [
                      if (isSelected)
                        Icon(Icons.check, color: AppColors.primary, size: 16.r)
                      else
                        SizedBox(width: 16.r),
                      SizedBox(width: 8.w),
                      Text(
                        opt,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    Icon(Icons.sort, color: labelColor, size: 16.r),
                    SizedBox(width: 8.w),
                    ValueListenableBuilder<String>(
                      valueListenable: sortByNotifier,
                      builder: (context, sortBy, _) {
                        return Text(
                          sortBy == 'None' ? "Sort" : sortBy,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // List/Grid Toggle
        ValueListenableBuilder<bool>(
          valueListenable: isListViewNotifier,
          builder: (context, isList, _) {
            final activeColor = AppColors.primary;
            final inactiveColor = labelColor;
            final activeBg = activeColor.withValues(alpha: 0.15);

            return Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  // List Layout Button
                  InkWell(
                    onTap: () => isListViewNotifier.value = true,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.r),
                      bottomLeft: Radius.circular(8.r),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: isList ? activeBg : Colors.transparent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.r),
                          bottomLeft: Radius.circular(8.r),
                        ),
                      ),
                      child: Icon(
                        Icons.list,
                        color: isList ? activeColor : inactiveColor,
                        size: 20.r,
                      ),
                    ),
                  ),
                  Container(
                    width: 1.2,
                    height: 20.h,
                    color: borderColor,
                  ),
                  // Grid Layout Button
                  InkWell(
                    onTap: () => isListViewNotifier.value = false,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8.r),
                      bottomRight: Radius.circular(8.r),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: !isList ? activeBg : Colors.transparent,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8.r),
                          bottomRight: Radius.circular(8.r),
                        ),
                      ),
                      child: Icon(
                        Icons.grid_view,
                        color: !isList ? activeColor : inactiveColor,
                        size: 20.r,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
