import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class LabSummaryCard extends StatelessWidget {
  final Map<String, dynamic> lab;
  final VoidCallback? onViewAll;

  const LabSummaryCard({super.key, required this.lab, this.onViewAll});

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

    final totalTests = lab['totalTests']?.toString() ?? '185';
    final pending = lab['pending']?.toString() ?? '12';
    final critical = lab['criticalAlerts']?.toString() ?? '5';

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.biotech_outlined,
                    color: AppColors.primary,
                    size: 16.r,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "Lab Summary",
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: onViewAll,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  AppStrings.viewAll,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMiniStat(
                context,
                value: totalTests,
                label: AppStrings.totalTests,
                color: textColor,
              ),
              _buildMiniStat(
                context,
                value: pending,
                label: AppStrings.pending,
                color: AppColors.primary,
              ),
              _buildMiniStat(
                context,
                value: critical,
                label: AppStrings.criticalAlerts,
                color: AppColors.error,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(
    BuildContext context, {
    required String value,
    required String label,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark
        ? AppColors.terminalDarkLabel
        : AppColors.terminalLightLabel;

    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 12.sp,
          ),
        ),

        Text(
          label.toUpperCase(),
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: 8.sp,
            fontWeight: FontWeight.bold,
            color: labelColor,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}
