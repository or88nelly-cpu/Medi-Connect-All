import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class StaffHeader extends StatelessWidget {
  const StaffHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (Navigator.of(context).canPop()) ...[
              IconButton(
                icon: Icon(Icons.arrow_back, color: textColor),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.of(context).pop(),
              ),
              SizedBox(width: 12.w),
            ],
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Staff",
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontSize: 24.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "Manage and view all staff",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: labelColor,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            _buildRoundHeaderButton(context, Icons.search, () {}),
            SizedBox(width: 8.w),
            _buildRoundHeaderButton(context, Icons.filter_list, () {}),
            SizedBox(width: 8.w),
            _buildRoundHeaderButton(context, Icons.more_vert, () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildRoundHeaderButton(BuildContext context, IconData icon, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final btnBg = isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.05);
    final iconColor = isDark ? Colors.white : AppColors.terminalLightText;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: btnBg,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 18.r),
      ),
    );
  }
}
