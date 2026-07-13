import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class PatientRegistrySearchHeader extends StatelessWidget {
  final TextEditingController searchController;
  final ValueNotifier<String> filterNotifier;
  final ValueNotifier<String> queryNotifier;
  final int recordCount;

  const PatientRegistrySearchHeader({
    super.key,
    required this.searchController,
    required this.filterNotifier,
    required this.queryNotifier,
    required this.recordCount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = AppColors.border(context);
    final textColor = AppColors.textPrimary(context);
    final fieldFillColor = isDark
        ? AppColors.terminalDarkFieldFill
        : AppColors.terminalLightFieldFill;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.badge_outlined, color: AppColors.primary, size: 22.r),
            SizedBox(width: 8.w),
            Text(
              "Patient Registry Records",
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                "$recordCount Records",
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: ValueListenableBuilder<String>(
                valueListenable: filterNotifier,
                builder: (context, filter, _) {
                  return TextField(
                    controller: searchController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: fieldFillColor,
                      hintText: "Search patient by ${filter.toLowerCase()}...",
                      hintStyle: TextStyle(
                        color: isDark
                            ? AppColors.terminalDarkFieldHint
                            : AppColors.terminalLightFieldHint,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.textSecondary(context),
                      ),
                      contentPadding: EdgeInsets.all(12.r),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 8.w),
            ValueListenableBuilder<String>(
              valueListenable: filterNotifier,
              builder: (context, filter, _) {
                return DropdownButton<String>(
                  value: filter,
                  dropdownColor: isDark
                      ? AppColors.terminalDarkCard
                      : AppColors.surface,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                  underline: const SizedBox(),
                  items: ['Name', 'UHID', 'Phone'].map((String val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      filterNotifier.value = val;
                    }
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
