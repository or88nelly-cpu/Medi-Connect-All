import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

class ScheduleStatusChips extends StatelessWidget {
  final String selectedStatus;
  final ValueChanged<String> onStatusSelected;

  const ScheduleStatusChips({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  Color _getChipBgColor(String status, bool isDark) {
    if (status == 'All') return const Color(0xFF0F6FFF).withValues(alpha: 0.1);
    switch (status) {
      case 'Confirmed':
        return isDark
            ? AppColors.statusConfirmedBgDark.withValues(alpha: 0.3)
            : AppColors.statusConfirmedBgLight;
      case 'Pending MRD':
        return isDark
            ? const Color(0xFF3B0764).withValues(alpha: 0.3)
            : const Color(0xFFF3E8FF);
      case 'Pending':
        return isDark
            ? AppColors.statusPendingBgDark.withValues(alpha: 0.3)
            : AppColors.statusPendingBgLight;
      case 'Completed':
        return isDark
            ? AppColors.statusCompletedBgDark.withValues(alpha: 0.3)
            : AppColors.statusCompletedBgLight;
      case 'Cancelled':
      default:
        return isDark
            ? AppColors.statusCancelledBgDark.withValues(alpha: 0.3)
            : AppColors.statusCancelledBgLight;
    }
  }

  Color _getChipBorderColor(String status, bool isDark) {
    if (status == 'All') return const Color(0xFF0F6FFF).withValues(alpha: 0.3);
    switch (status) {
      case 'Confirmed':
        return AppColors.success.withValues(alpha: 0.3);
      case 'Pending MRD':
        return AppColors.infoPurple.withValues(alpha: 0.3);
      case 'Pending':
        return AppColors.warning.withValues(alpha: 0.3);
      case 'Completed':
        return AppColors.infoPurple.withValues(alpha: 0.3);
      case 'Cancelled':
      default:
        return AppColors.error.withValues(alpha: 0.3);
    }
  }

  Color _getChipTextColor(String status, bool isDark) {
    if (status == 'All') return const Color(0xFF0F6FFF);
    switch (status) {
      case 'Confirmed':
        return isDark
            ? AppColors.statusConfirmedTextDark
            : AppColors.statusConfirmedTextLight;
      case 'Pending MRD':
        return isDark ? const Color(0xFFC084FC) : const Color(0xFF7E22CE);
      case 'Pending':
        return isDark
            ? AppColors.statusPendingTextDark
            : AppColors.statusPendingTextLight;
      case 'Completed':
        return isDark
            ? AppColors.statusCompletedTextDark
            : AppColors.statusCompletedTextLight;
      case 'Cancelled':
      default:
        return isDark
            ? AppColors.statusCancelledTextDark
            : AppColors.statusCancelledTextLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: ['All', 'Confirmed', 'Pending', 'Completed', 'Cancelled'].map(
          (status) {
            final isSelected = selectedStatus == status;
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: ChoiceChip(
                label: Text(
                  status,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : _getChipTextColor(status, isDark),
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
                selected: isSelected,
                selectedColor: const Color(0xFF0F6FFF),
                backgroundColor: _getChipBgColor(status, isDark),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  side: BorderSide(
                    color: isSelected
                        ? Colors.transparent
                        : _getChipBorderColor(status, isDark),
                  ),
                ),
                showCheckmark: false,
                onSelected: (selected) {
                  if (selected) {
                    onStatusSelected(status);
                  }
                },
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
