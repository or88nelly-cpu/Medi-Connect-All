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
    final surfaceColor = Theme.of(context).colorScheme.surface;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 20.r,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 1. Home
              _buildNavItem(
                context,
                index: 0,
                outlineIcon: Icons.home_outlined,
                solidIcon: Icons.home,
                label: 'Home',
              ),

              // 2. Health Record
              _buildNavItem(
                context,
                index: 1,
                outlineIcon: Icons.assignment_outlined,
                solidIcon: Icons.assignment,
                label: 'Health Record',
              ),

              // 3. Profile
              _buildNavItem(
                context,
                index: 2,
                outlineIcon: Icons.person_outline,
                solidIcon: Icons.person,
                label: 'Profile',
              ),

              // 4. Premium (Mockup styled with golden crown pill background)
              _buildPremiumNavItem(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData outlineIcon,
    required IconData solidIcon,
    required String label,
  }) {
    final isSelected = currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isSelected
        ? AppColors.primary
        : (isDark ? Colors.white54 : AppColors.textSecondary(context));

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? solidIcon : outlineIcon,
              color: color,
              size: 20.r,
            ),
            SizedBox(height: 3.h),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: color,
                fontSize: 8.5.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumNavItem(BuildContext context) {
    const premiumIndex = 3;
    final isSelected = currentIndex == premiumIndex;

    return InkWell(
      onTap: () => onTap(premiumIndex),
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFF7C325), Color(0xFFE29E0D)],
                )
              : LinearGradient(
                  colors: [
                    const Color(0xFFF7C325).withValues(alpha: 0.08),
                    const Color(0xFFE29E0D).withValues(alpha: 0.12),
                  ],
                ),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: AppColors.secondary.withValues(alpha: isSelected ? 1 : 0.4),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.25),
                    blurRadius: 8.r,
                    offset: const Offset(0, 3),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.workspace_premium_rounded,
              color: isSelected ? Colors.white : AppColors.secondary,
              size: 18.r,
            ),
            SizedBox(width: 6.w),
            Text(
              'Premium',
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? Colors.white : AppColors.secondary,
                fontSize: 9.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
