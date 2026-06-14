import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/common_widgets/buttons/gradient_button.dart';

class AppointmentsHeader extends StatelessWidget {
  final VoidCallback onBookNew;

  const AppointmentsHeader({
    super.key,
    required this.onBookNew,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppStrings.appointments,
          style: AppTextStyles.headingMedium.copyWith(
            fontSize: 22.sp,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        GradientButton(
          text: "Book New",
          onPressed: onBookNew,
          width: 120.w,
          height: 40.h,
          borderRadius: 10.r,
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
