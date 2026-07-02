import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class PatientIdChip extends StatelessWidget {
  final String patientId;

  const PatientIdChip({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    // Truncate long UUIDs to fit neatly within the display chip and prevent overflows
    final displayId = patientId.length > 15 
        ? '${patientId.substring(0, 8)}...${patientId.substring(patientId.length - 4)}' 
        : patientId;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 5.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.dashboardCardBg(context),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.border(context),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(
              alpha: 0.07,
            ),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person_outline,
            size: 13.r,
            color: AppColors.primary,
          ),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              'Patient ID: $displayId',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 11.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
