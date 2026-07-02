import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/functions/app_responsive.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class LoginWelcomeText extends StatelessWidget {
  const LoginWelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = AppResponsive.isDesktop(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Welcome Back!',
          style: AppTextStyles.headingLarge.copyWith(
            fontSize: isDesktop ? 32.sp : 26.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary(context),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Login to access your\nhealthcare services',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary(context),
            height: 1.4,
            fontSize: isDesktop ? 14.sp : 13.sp,
          ),
        ),
      ],
    );
  }
}
