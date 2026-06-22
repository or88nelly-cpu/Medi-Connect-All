import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class StaffAttendanceCard extends StatelessWidget {
  final Map<String, dynamic> attendance;
  final VoidCallback? onViewAll;

  const StaffAttendanceCard({
    super.key,
    required this.attendance,
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
    final labelColor = isDark
        ? AppColors.terminalDarkLabel
        : AppColors.terminalLightLabel;

    final int present = (attendance['present'] as num?)?.toInt() ?? 1;
    final int absent = (attendance['absent'] as num?)?.toInt() ?? 0;
    final int onLeave = (attendance['onLeave'] as num?)?.toInt() ?? 0;
    final int total = present + absent + onLeave;

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
                    Icons.edit_document,
                    color: AppColors.primary,
                    size: 16.r,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "Staff Attendance",
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
            children: [
              Expanded(
                flex: 4,
                child: Center(
                  child: SizedBox(
                    width: 80.r,
                    height: 80.r,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 80.r,
                          width: 80.r,
                          child: CircularProgressIndicator(
                            value: total > 0 ? present / total : 0,
                            strokeWidth: 8.r,

                            backgroundColor: AppColors.border(context),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              total.toString(),
                              style: AppTextStyles.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                fontSize: 14.sp,
                                height: 1.1,
                              ),
                            ),
                            Text(
                              "Total",
                              style: AppTextStyles.bodySmall.copyWith(
                                color: labelColor,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem(
                      label: AppStrings.present,
                      value: present,
                      color: AppColors.primary,
                    ),
                    SizedBox(height: 8.h),
                    _buildLegendItem(
                      label: AppStrings.absent,
                      value: absent,
                      color: AppColors.error,
                    ),
                    SizedBox(height: 8.h),
                    _buildLegendItem(
                      label: AppStrings.onLeave,
                      value: onLeave,
                      color: AppColors.accent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required String label,
    required int value,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8.r,
              height: 8.r,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          value.toString(),
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
