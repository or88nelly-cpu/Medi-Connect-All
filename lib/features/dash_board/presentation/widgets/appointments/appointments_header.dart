import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class AppointmentsHeader extends StatelessWidget {
  final VoidCallback onBookNew;

  const AppointmentsHeader({super.key, required this.onBookNew});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.appointments,
              style: AppTextStyles.headingMedium.copyWith(
                fontSize: 16.sp,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),

            Text(
              "Manage and track all patient appointments",
              style: AppTextStyles.bodySmall.copyWith(
                color: isDark ? Colors.white54 : AppColors.textSecondary,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
