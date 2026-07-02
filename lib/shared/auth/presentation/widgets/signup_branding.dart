import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/functions/app_responsive.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/constants/app_assets.dart';

class SignupBranding extends StatelessWidget {
  const SignupBranding({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = AppResponsive.isDesktop(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: CustomImageView(
            imagePath: AppAssets.logoIconPng,
            width: isDesktop ? 62.r : 56.r,
            height: isDesktop ? 62.r : 56.r,
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
                      fontSize: isDesktop ? 22.sp : 16.sp,
                      color: AppColors.primary,
                    ),
                  ),
                  TextSpan(
                    text: 'Connect',
                    style: AppTextStyles.headingMedium.copyWith(
                      fontSize: isDesktop ? 22.sp : 16.sp,
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
                fontSize: isDesktop ? 11.sp : 9.sp,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
