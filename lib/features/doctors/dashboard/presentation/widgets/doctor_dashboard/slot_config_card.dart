import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class SlotConfigCard extends StatelessWidget {
  final String availableSlotsCount;
  final VoidCallback onTap;

  const SlotConfigCard({
    super.key,
    required this.availableSlotsCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.info.withValues(alpha: 0.8),
                        AppColors.info,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.settings_suggest_rounded,
                    color: Colors.white,
                    size: 18.r,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    AppStrings.slotConfigTitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDark
                          ? AppColors.terminalDarkLabel
                          : AppColors.info,
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              availableSlotsCount,
              style: AppTextStyles.headingLarge.copyWith(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w900,
                fontSize: 28.sp,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              AppStrings.slotConfigSubtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: isDark ? AppColors.darkTextSecondary : Colors.grey[500],
                fontSize: 10.sp,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(
                  Icons.edit_calendar_rounded,
                  color: AppColors.info,
                  size: 12.r,
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    AppStrings.slotConfigManage,
                    style: TextStyle(
                      color: AppColors.info,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
