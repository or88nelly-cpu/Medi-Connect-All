import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/cards/admin_logo_section.dart';

import 'package:medi_connect/core/constants/app_strings.dart';

class AdminHeader extends StatelessWidget {
  const AdminHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AdminLogoSection(padding: 0.r, size: 120.r, decorationNeeded: false),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.brandMedi,
              style: AppTextStyles.headingMedium.copyWith(
                color: AppColors.textDarkNavy,
                fontSize: 26.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              AppStrings.brandConnect,
              style: AppTextStyles.headingMedium.copyWith(
                color: AppColors.primary,
                fontSize: 26.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
