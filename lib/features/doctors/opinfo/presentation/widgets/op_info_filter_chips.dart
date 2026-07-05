import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class OpInfoFilterChips extends StatelessWidget {
  final String activeFilter;
  final int total;
  final int pending;
  final int completed;
  final int cancelled;
  final ValueChanged<String> onFilterChanged;

  const OpInfoFilterChips({
    super.key,
    required this.activeFilter,
    required this.total,
    required this.pending,
    required this.completed,
    required this.cancelled,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      (AppStrings.opInfoFilterAll, total, AppColors.infoPurple),
      (AppStrings.opInfoFilterPending, pending, AppColors.infoOrange),
      (AppStrings.opInfoFilterCompleted, completed, AppColors.success),
      (AppStrings.opInfoFilterCancelled, cancelled, AppColors.error),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: filters.map((item) {
          final (label, count, color) = item;
          final isActive = activeFilter == label;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: _FilterChip(
              label: label,
              count: count,
              color: color,
              isActive: isActive,
              onTap: () => onFilterChanged(label),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.color,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isActive
              ? color
              : (isDark ? AppColors.darkCard : AppColors.lightCard),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isActive ? color : color.withValues(alpha: 0.5),
            width: isActive ? 0 : 1,
          ),
        ),
        child: Text(
          '$label ($count)',
          style: AppTextStyles.bodySmall.copyWith(
            color: isActive ? AppColors.textLight : color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
