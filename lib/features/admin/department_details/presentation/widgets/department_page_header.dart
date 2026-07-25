import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

/// Page header matching the Department Management design.
/// Blue shield badge left + title/subtitle + hospital artwork right.
class DepartmentPageHeader extends StatelessWidget {
  const DepartmentPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Shield icon badge
        Container(
          width: 52.r,
          height: 52.r,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.controlCenterBlue,
                AppColors.controlCenterPurple,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.controlCenterBlue.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(Icons.shield_rounded, size: 28.r, color: Colors.white),
        ),
        SizedBox(width: 14.w),
        // Title block
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Department Management',
                style: TextStyle(
                  fontSize: isMobile ? 20.sp : 26.sp,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : AppColors.textDarkNavy,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Admin Dashboard',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.controlCenterBlue,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Efficiently manage and monitor all hospital departments.',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.grey.shade500,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        // Hospital artwork
        if (!isMobile) _HospitalArt(),
      ],
    );
  }
}

class _HospitalArt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
      height: 90.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.06),
            AppColors.controlCenterPurple.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: Icon(
          Icons.local_hospital_rounded,
          size: 52.r,
          color: AppColors.primary.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
