import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class DepartmentOverviewCard extends StatelessWidget {
  final List<dynamic> deptStats;

  const DepartmentOverviewCard({
    super.key,
    required this.deptStats,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;

    // We can map mock progress capacity metrics as shown in the mockup:
    // General Medicine: 52% capacity (or dynamic stats, defaults to 52%)
    // Cardiology: 40% capacity (defaults to 40%)
    // Neurology: 91% capacity (defaults to 91%)
    final List<Map<String, dynamic>> items = [
      {
        'name': 'General Medicine',
        'value': 0.52,
        'color': AppColors.primary,
        'label': '52% capacity',
      },
      {
        'name': 'Cardiology',
        'value': 0.40,
        'color': AppColors.primary, // Blue in mockup or cyan
        'label': '40% capacity',
      },
      {
        'name': 'Neurology',
        'value': 0.91,
        'color': AppColors.error,
        'label': '91% capacity',
      },
    ];

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
            children: [
              Icon(
                Icons.add_box_outlined,
                color: AppColors.primary,
                size: 20.r,
              ),
              SizedBox(width: 8.w),
              Text(
                "Department Overview",
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            AppStrings.capacityUtilization,
            style: AppTextStyles.bodySmall.copyWith(
              color: labelColor,
              fontSize: 11.sp,
            ),
          ),
          SizedBox(height: 16.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, idx) => SizedBox(height: 12.h),
            itemBuilder: (context, idx) {
              final item = items[idx];
              final name = item['name'] as String;
              final val = item['value'] as double;
              final color = item['color'] as Color;
              final capText = item['label'] as String;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                      Text(
                        capText,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: labelColor,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: val,
                      backgroundColor: isDark ? AppColors.terminalDarkBorder : AppColors.border,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 8.h,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
