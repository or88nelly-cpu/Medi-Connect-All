import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/functions/app_responsive.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class SignupWelcomeText extends StatelessWidget {
  const SignupWelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = AppResponsive.isDesktop(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create Your Account',
          style: AppTextStyles.headingLarge.copyWith(
            fontSize: isDesktop ? 32.sp : 18.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary(context),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Join us to access world-class\nhealthcare services',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary(context),
            height: 1.4,
            fontSize: isDesktop ? 14.sp : 11.sp,
          ),
        ),
      ],
    );
  }
}
