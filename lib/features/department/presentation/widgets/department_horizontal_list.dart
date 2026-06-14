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
  final String title;
  final Color? color;
  final List<DepartmentEntity> departments;

  const DepartmentHorizontalList({
    super.key,
    required this.departments,
    this.isAdmin = false,
    required this.title,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool isSection = title.toLowerCase().contains("section");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ─────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: isDark
                    ? AppColors.terminalDarkText
                    : AppColors.terminalLightText,
              ),
            ),
            TextButton(
              onPressed: () =>
                  context.push(isSection ? "/sections" : '/departments'),
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
          isSection
              ? SizedBox(
                  height: 80.r,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(
                      left: 2.w,
                      right: 2.w,
                      bottom: 4.h,
                    ),
                    itemCount: departments.length.clamp(0, 5),
                    itemBuilder: (context, index) {
                      final dept = departments[index];
                      return DepartmentCard(
                        isHorizontal: true,
                        department: dept,
                        isSection: true,
                        color: color,
                        isAdmin: isAdmin,
                        width: 80.r,
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
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: departments.length.clamp(0, 12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.r,
                    mainAxisSpacing: 8.r,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final dept = departments[index];
                    return DepartmentCard(
                      department: dept,
                      isSection: isSection,
                      isAdmin: false,
                      color: color,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: isDark ? AppColors.terminalDarkCard : AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AppColors.terminalDarkBorder : AppColors.border,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        AppStrings.noDepartments,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isDark ? AppColors.terminalDarkLabel : AppColors.textSecondary,
        ),
      ),
    );
  }
}
