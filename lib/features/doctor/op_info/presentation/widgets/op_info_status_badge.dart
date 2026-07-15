import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class OpInfoStatusBadge extends StatelessWidget {
  final String status;

  const OpInfoStatusBadge({super.key, required this.status});

  Color _bgColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (status.toLowerCase()) {
      case 'pending':
        return isDark
            ? AppColors.statusPendingBgDark
            : AppColors.statusPendingBgLight;
      case 'completed':
        return isDark
            ? AppColors.statusConfirmedBgDark
            : AppColors.statusConfirmedBgLight;
      case 'cancelled':
        return isDark
            ? AppColors.statusCancelledBgDark
            : AppColors.statusCancelledBgLight;
      default:
        return AppColors.divider;
    }
  }

  Color _textColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (status.toLowerCase()) {
      case 'pending':
        return isDark
            ? AppColors.statusPendingTextDark
            : AppColors.statusPendingTextLight;
      case 'completed':
        return isDark
            ? AppColors.statusConfirmedTextDark
            : AppColors.statusConfirmedTextLight;
      case 'cancelled':
        return isDark
            ? AppColors.statusCancelledTextDark
            : AppColors.statusCancelledTextLight;
      default:
        return AppColors.textSecondary(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _bgColor(context),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status,
        style: AppTextStyles.labelSmall.copyWith(
          color: _textColor(context),
          fontWeight: FontWeight.bold,
          fontSize: 10.sp,
        ),
      ),
    );
  }
}
