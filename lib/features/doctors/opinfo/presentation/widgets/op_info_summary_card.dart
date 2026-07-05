import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_assets.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/features/doctors/opinfo/presentation/widgets/op_info_stat_item.dart';

class OpInfoSummaryCard extends StatelessWidget {
  final int total;
  final int pending;
  final int completed;
  final int cancelled;

  const OpInfoSummaryCard({
    super.key,
    required this.total,
    required this.pending,
    required this.completed,
    required this.cancelled,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightShadow,
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImageView(
            imagePath: AppAssets.appointments,
            width: 80.r,
            height: 80.r,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.opInfoTitle,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  AppStrings.opInfoSubtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: OpInfoStatItem(
                        icon: Icons.people_outline,
                        count: total,
                        label: AppStrings.opInfoTotalProcedures,
                        color: AppColors.infoPurple,
                      ),
                    ),
                    Expanded(
                      child: OpInfoStatItem(
                        icon: Icons.schedule,
                        count: pending,
                        label: AppStrings.opInfoPendingProcedures,
                        color: AppColors.infoOrange,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: OpInfoStatItem(
                        icon: Icons.check_circle_outline,
                        count: completed,
                        label: AppStrings.opInfoCompletedProcedures,
                        color: AppColors.success,
                      ),
                    ),
                    Expanded(
                      child: OpInfoStatItem(
                        icon: Icons.cancel_outlined,
                        count: cancelled,
                        label: AppStrings.opInfoCancelledProcedures,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
