import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/constants/app_assets.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/buttons/common_button.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';

class OpInfoDateCard extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const OpInfoDateCard({
    super.key,
    required this.selectedDate,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM dd, yyyy').format(selectedDate);
    final dayStr = DateFormat('EEEE').format(selectedDate);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.lightHeaderStart, AppColors.lightHeaderEnd],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: AppColors.textLight.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: CustomImageView(
              imagePath: AppAssets.calendar3d,
              width: 28.r,
              height: 28.r,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.opInfoTodaysDate,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textLight.withValues(alpha: 0.8),
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  dateStr,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  dayStr,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textLight.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          CommonButton(
            width: 36.r,
            height: 36.r,
            borderRadius: 10.r,
            color: AppColors.textLight.withValues(alpha: 0.15),
            onPressed: onPrevious,
            child: Icon(
              Icons.chevron_left,
              color: AppColors.textLight,
              size: 20.r,
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.textLight.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppColors.textLight,
                  size: 14.r,
                ),
                SizedBox(height: 2.h),
                Text(
                  dateStr,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textLight,
                    fontSize: 8.sp,
                  ),
                ),
                Text(
                  dayStr,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textLight.withValues(alpha: 0.8),
                    fontSize: 7.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          CommonButton(
            width: 36.r,
            height: 36.r,
            borderRadius: 10.r,
            color: AppColors.textLight.withValues(alpha: 0.15),
            onPressed: onNext,
            child: Icon(
              Icons.chevron_right,
              color: AppColors.textLight,
              size: 20.r,
            ),
          ),
        ],
      ),
    );
  }
}
