import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class AdminNavItem extends StatelessWidget {
  final int index;
  final IconData outlineIcon;
  final IconData solidIcon;
  final String label;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AdminNavItem({
    super.key,
    required this.index,
    required this.outlineIcon,
    required this.solidIcon,
    required this.label,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentIndex == index;
    final color = isSelected ? AppColors.primary : AppColors.textSecondary;

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? solidIcon : outlineIcon,
              color: color,
              size: 24.r,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: color,
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
