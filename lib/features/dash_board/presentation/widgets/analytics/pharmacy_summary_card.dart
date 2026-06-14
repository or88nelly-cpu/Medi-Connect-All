import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class PharmacySummaryCard extends StatelessWidget {
  final Map<String, dynamic> pharmacy;
  final VoidCallback? onViewAll;

  const PharmacySummaryCard({
    super.key,
    required this.pharmacy,
    this.onViewAll,
  });

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

    final totalMeds = pharmacy['totalMedicines']?.toString() ?? '420';
    final lowStock = pharmacy['lowStock']?.toString() ?? '8';
    final outOfStock = pharmacy['outOfStock']?.toString() ?? '3';

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
                    Icons.medical_services_sharp,
                    color: AppColors.primary,
                    size: 20.r,
                  ),
                  SizedBox(width: 8.r),
                  Text(
                    AppStrings.pharmacySummary,
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
                value: totalMeds,
                label: AppStrings.inStock,
                color: textColor,
              ),
              _buildMiniStat(
                context,
                value: lowStock,
                label: AppStrings.expired,
                color: AppColors.primary,
              ),
              _buildMiniStat(
                context,
                value: outOfStock,
                label: AppStrings.outOfStock,
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
            fontSize: 16.sp,
          ),
        ),
        //  SizedBox(height: 4.h),
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
