import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/constants/app_assets.dart';

class LoginBranding extends StatelessWidget {
  const LoginBranding({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          // padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            // color: AppColors.background(context),
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              // BoxShadow(
              //   color: AppColors.primary.withValues(alpha: 0.08),
              //   blurRadius: 16.r,
              //   offset: const Offset(0, 4),
              // ),
            ],
          ),
          child: CustomImageView(
            imagePath: AppAssets.logoIconPng,
            width: 62.r,
            height: 62.r,
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Medi',
                    style: AppTextStyles.headingMedium.copyWith(
                      fontSize: 22.sp,
                      color: AppColors.primary,
                    ),
                  ),
                  TextSpan(
                    text: 'Connect',
                    style: AppTextStyles.headingMedium.copyWith(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDarkNavy,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Multi Speciality Hospital',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary(context),
                fontSize: 11.sp,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
