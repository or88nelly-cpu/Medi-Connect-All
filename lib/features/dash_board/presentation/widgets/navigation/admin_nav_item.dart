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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final color = isSelected
        ? AppColors.primary
        : (isDark ? Colors.white54 : AppColors.textSecondary);

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? solidIcon : outlineIcon,
                key: ValueKey(isSelected),
                color: color,
                size: 20.r,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: color,
                fontSize: 9.sp,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
