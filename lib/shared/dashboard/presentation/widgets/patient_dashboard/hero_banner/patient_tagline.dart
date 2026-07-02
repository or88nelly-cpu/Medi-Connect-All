import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class PatientTagline extends StatelessWidget {
  const PatientTagline({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.favorite_outline,
          size: 16.r,
          color: AppColors.primary,
        ),
        SizedBox(width: 6.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'We are here to',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary(context),
                fontSize: 11.sp,
              ),
            ),
            Text(
              'care for you',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
