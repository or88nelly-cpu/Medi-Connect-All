import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/functions/app_responsive.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class SignupWelcomeText extends StatelessWidget {
  const SignupWelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = AppResponsive.isDesktop(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Create Your Account',
          style: AppTextStyles.headingLarge.copyWith(
            fontSize: isDesktop ? 32.sp : 22.sp,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : AppColors.primary,
          ),
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
        ),
        SizedBox(height: 6.h),
        Text(
          'Join us to access world-class healthcare services',
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? Colors.white.withValues(alpha: 0.8) : Colors.black87,
            height: 1.3,
            fontSize: isDesktop ? 14.sp : 12.sp,
          ),
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
        ),
      ],
    );
  }
}
