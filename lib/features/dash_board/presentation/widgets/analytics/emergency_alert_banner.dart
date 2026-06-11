import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class EmergencyAlertBanner extends StatelessWidget {
  final List<dynamic> emergencies;
  final VoidCallback? onViewAll;

  const EmergencyAlertBanner({
    super.key,
    required this.emergencies,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final first = emergencies.isNotEmpty
        ? emergencies.first
        : {
            'message': 'CODE RED',
            'time': '7m ago',
          };

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final alertMessage = first['message'] as String? ?? 'CODE RED';
    final alertTime = first['time'] as String? ?? '7m ago';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.error, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.gpp_bad,
              color: Colors.white,
              size: 24.r,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "EMERGENCY ALERT: $alertMessage",
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "Emergency Ward • Room 502 • Triggered $alertTime",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark ? Colors.white70 : AppColors.textSecondary,
                    fontSize: 10.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          TextButton(
            onPressed: onViewAll,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              AppStrings.viewAll.toUpperCase(),
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
                fontSize: 11.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
