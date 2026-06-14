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
        : {'message': 'CODE RED', 'time': '7m ago'};

    final alertMessage = first['message'] as String? ?? 'CODE RED';
    final alertTime = first['time'] as String? ?? '7m ago';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.adminSecondary.withAlpha(80),
            AppColors.error.withAlpha(200),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.error, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.gpp_bad, color: Colors.white, size: 40.r),
          SizedBox(width: 8.r),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "EMERGENCY ALERT",
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.surface,
                    fontSize: 12.sp,
                  ),
                ),
                Text(
                  alertMessage,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.surface,
                    fontSize: 8.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "Emergency Ward • Room 502 • Triggered $alertTime",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white70,
                    fontSize: 7.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 8.r),
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
                color: AppColors.surface,
                fontWeight: FontWeight.bold,
                fontSize: 8.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
