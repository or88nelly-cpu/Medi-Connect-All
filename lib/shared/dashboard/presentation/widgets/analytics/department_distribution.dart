import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class DepartmentDistribution extends StatelessWidget {
  final List<dynamic> deptStats;

  const DepartmentDistribution({super.key, required this.deptStats});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.h,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.departmentDistribution,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: ListView.separated(
              itemCount: deptStats.length,
              physics: const ClampingScrollPhysics(),
              separatorBuilder: (context, index) => SizedBox(height: 10.h),
              itemBuilder: (context, index) {
                final item = deptStats[index] as Map<dynamic, dynamic>;
                final name = item['department'] ?? AppStrings.other;
                final count = item['count'] ?? 0;
                final double progress = (count / 15).clamp(
                  0.0,
                  1.0,
                ); // Assume max 15 doctors in a dept

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(name, style: AppTextStyles.bodyMedium),
                        Text(
                          "$count${AppStrings.docsLabel}",
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColors.border(context),
                        color: AppColors.primary,
                        minHeight: 6.h,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
