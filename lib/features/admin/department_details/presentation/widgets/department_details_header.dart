import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

/// Header row for the Department Details page with back button, title, and subtitle.
class DepartmentDetailsHeader extends StatelessWidget {
  const DepartmentDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: isDark ? Colors.white : AppColors.textDarkNavy,
            size: 24.r,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.departmentDetailsTitle,
                style: AppTextStyles.headingLarge.copyWith(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : AppColors.textDarkNavy,
                ),
              ),
              Text(
                AppStrings.departmentDetailsSubtitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 12.sp,
                  color: isDark ? Colors.white60 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
