import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class LoginSecurityFooter extends StatelessWidget {
  const LoginSecurityFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.verified_user_rounded,
            color: AppColors.primary,
            size: 16.r,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          'Your health data is safe and secure with us.',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary(context),
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
