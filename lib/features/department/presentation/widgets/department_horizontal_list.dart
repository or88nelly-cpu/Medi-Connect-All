import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/department/domain/entities/department_entity.dart';
import 'package:medi_connect/features/department/presentation/bloc/department_bloc.dart';
import 'package:medi_connect/features/department/presentation/widgets/department_card.dart';
import 'package:medi_connect/features/department/presentation/widgets/department_form_dialog.dart';

/// A horizontal scrollable list of department cards displayed on any dashboard.
/// Accepts an optional [isAdmin] flag to show admin controls.
class DepartmentHorizontalList extends StatelessWidget {
  final bool isAdmin;
  final List<DepartmentEntity> departments;

  const DepartmentHorizontalList({
    super.key,
    required this.departments,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ─────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.departments,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/departments'),
              child: Text(
                AppStrings.viewAll,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),

        // ── Horizontal list ────────────────────────────────
        if (departments.isEmpty)
          _EmptyDepartmentsStrip()
        else
          SizedBox(
            height: isAdmin ? 168.h : 138.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 2.w, right: 2.w, bottom: 4.h),
              itemCount: departments.length,
              itemBuilder: (context, index) {
                final dept = departments[index];
                return DepartmentCard(
                  department: dept,
                  isAdmin: isAdmin,
                  onEdit: isAdmin
                      ? () => DepartmentFormDialog.show(
                          context,
                          existingDepartment: dept,
                        )
                      : null,
                  onDelete: isAdmin
                      ? () => _confirmDelete(context, dept)
                      : null,
                );
              },
            ),
          ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, DepartmentEntity dept) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          AppStrings.deleteDepartment,
          style: AppTextStyles.titleMedium,
        ),
        content: Text(
          AppStrings.confirmDeleteDepartment,
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppStrings.cancel,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<DepartmentBloc>().add(
                DeleteDepartmentEvent(dept.id),
              );
            },
            child: Text(
              AppStrings.deleteDepartment,
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDepartmentsStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      alignment: Alignment.center,
      child: Text(
        AppStrings.noDepartments,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
