import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class PatientBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const PatientBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? .30 : .08),
              blurRadius: 25,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _navItem(
                context,
                0,
                Icons.home_outlined,
                Icons.home_rounded,
                "Home",
              ),
            ),
            Expanded(
              child: _navItem(
                context,
                1,
                Icons.assignment_outlined,
                Icons.assignment_rounded,
                "Records",
              ),
            ),
            Expanded(
              child: _navItem(
                context,
                2,
                Icons.person_outline,
                Icons.person,
                "Profile",
              ),
            ),
            Expanded(child: _premiumItem(context)),
          ],
        ),
      ),
    );
  }

  Widget _navItem(
    BuildContext context,
    int index,
    IconData outline,
    IconData filled,
    String title,
  ) {
    final selected = currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutBack,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withAlpha(25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutBack,
              scale: selected ? 1.18 : 1,
              child: Icon(
                selected ? filled : outline,
                size: 24.r,
                color: selected
                    ? AppColors.primary
                    : (isDark ? Colors.white60 : Colors.grey.shade600),
              ),
            ),
            SizedBox(height: 4.h),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: selected ? 10.sp : 9.sp,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected ? AppColors.primary : Colors.grey,
              ),
              child: Text(title),
            ),
            SizedBox(height: 5.h),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              width: selected ? 20.w : 0,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _premiumItem(BuildContext context) {
    final selected = currentIndex == 3;

    return InkWell(
      onTap: () => onTap(3),
      borderRadius: BorderRadius.circular(20.r),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 350),
        scale: selected ? 1.08 : 1,
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            gradient: LinearGradient(
              colors: selected
                  ? const [Color(0xffFFD54F), Color(0xffFFB300)]
                  : [
                      const Color(0xffFFD54F).withAlpha(51),
                      const Color(0xffFFB300).withAlpha(31),
                    ],
            ),
            border: Border.all(color: const Color(0xffF4B400)),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.amber.withAlpha(85),
                      blurRadius: 18,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: selected ? 0.15 : 0),
                duration: const Duration(milliseconds: 400),
                builder: (_, value, child) {
                  return Transform.rotate(angle: value, child: child);
                },
                child: Icon(
                  Icons.workspace_premium_rounded,
                  color: selected ? Colors.white : const Color(0xffD89B00),
                  size: 24.r,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "Premium",
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.white : const Color(0xffD89B00),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
