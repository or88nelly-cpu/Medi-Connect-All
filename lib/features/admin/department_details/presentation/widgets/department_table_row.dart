import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/features/admin/staff_management/domain/entities/department_entity.dart';

/// Single DataRow representing one department entry in the table.
class DepartmentTableRow extends DataRow {
  DepartmentTableRow.fromEntity({
    required DepartmentEntity dept,
    required bool isDark,
  }) : super(
         cells: [
           // Department Code
           DataCell(
             Text(
               '${AppStrings.deptPrefix}${dept.id.substring(0, dept.id.length > 5 ? 5 : dept.id.length).toUpperCase()}',
               style: AppTextStyles.bodySmall.copyWith(
                 fontWeight: FontWeight.bold,
                 color: AppColors.controlCenterBlue,
               ),
             ),
           ),

           // Department Name + Icon
           DataCell(
             Row(
               children: [
                 CircleAvatar(
                   radius: 14.r,
                   backgroundColor: AppColors.controlCenterBlue.withValues(
                     alpha: 0.12,
                   ),
                   child: Icon(
                     Icons.corporate_fare_rounded,
                     size: 14.r,
                     color: AppColors.controlCenterBlue,
                   ),
                 ),
                 SizedBox(width: 10.w),
                 Text(
                   dept.name,
                   style: AppTextStyles.bodyMedium.copyWith(
                     fontWeight: FontWeight.bold,
                     color: isDark ? Colors.white : AppColors.textDarkNavy,
                   ),
                 ),
               ],
             ),
           ),

           // Description (used as Head of Department placeholder)
           DataCell(
             Text(
               dept.description?.isNotEmpty == true
                   ? dept.description!
                   : AppStrings.unassignedDoctor,
               style: AppTextStyles.bodySmall.copyWith(
                 color: isDark ? Colors.white70 : Colors.grey.shade700,
               ),
             ),
           ),

           // Consultation Status (used as Active/Inactive)
           DataCell(_DeptStatusBadge(isActive: dept.consultation)),

           // Actions
           DataCell(_DeptActionButtons(isDark: isDark)),
         ],
       );
}

// ---------------------------------------------------------------------------
// Private Sub-Widgets
// ---------------------------------------------------------------------------

class _DeptStatusBadge extends StatelessWidget {
  final bool isActive;
  const _DeptStatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.statusConfirmedBgLight
            : AppColors.statusCancelledBgLight,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        isActive ? AppStrings.active : AppStrings.inactive,
        style: TextStyle(
          color: isActive
              ? AppColors.statusConfirmedTextLight
              : AppColors.statusCancelledTextLight,
          fontWeight: FontWeight.bold,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}

class _DeptActionButtons extends StatelessWidget {
  final bool isDark;
  const _DeptActionButtons({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.visibility_outlined, size: 18.r),
          color: Colors.grey.shade600,
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.edit_outlined, size: 18.r),
          color: AppColors.controlCenterBlue,
          onPressed: () {},
        ),
      ],
    );
  }
}
