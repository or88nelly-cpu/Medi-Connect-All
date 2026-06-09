import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/background_wrapper.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/common_widgets/dialogs/dialogs.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/department/domain/entities/department_entity.dart';
import 'package:medi_connect/features/department/presentation/bloc/department_bloc.dart';
import 'package:medi_connect/features/department/presentation/widgets/department_card.dart';
import 'package:medi_connect/features/department/presentation/widgets/department_form_dialog.dart';

/// Full department list page accessible from all roles.
/// Admin users see edit/delete actions per card and a floating "Create New" FAB.
/// All roles see horizontal-first view with a "View All" toggle to full grid.
class DepartmentListPage extends StatelessWidget {
  const DepartmentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DepartmentBloc, DepartmentState>(
      listener: (context, state) {
        if (state is DepartmentActionSuccess) {
          // Refresh list with updated data after any action.
          context.read<DepartmentBloc>().add(const LoadDepartments());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is DepartmentError) {
          showDialog(
            context: context,
            builder: (_) => ErrorDialog(message: state.failure.message),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final isAdmin =
              authState is Authenticated && authState.user.role == 'admin';
          return _DepartmentListContent(isAdmin: isAdmin);
        },
      ),
    );
  }
}

class _DepartmentListContent extends StatefulWidget {
  final bool isAdmin;

  const _DepartmentListContent({required this.isAdmin});

  @override
  State<_DepartmentListContent> createState() => _DepartmentListContentState();
}

class _DepartmentListContentState extends State<_DepartmentListContent> {
  // ViewAll toggle — local UI-only state, acceptable with setState.
  final _showAllNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    context.read<DepartmentBloc>().add(const LoadDepartments());
  }

  @override
  void dispose() {
    _showAllNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarNeeded: true,
      customAppbar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          AppStrings.departmentsTitle,
          style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          BlocBuilder<DepartmentBloc, DepartmentState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(Icons.refresh, size: 22.r),
                onPressed: () =>
                    context.read<DepartmentBloc>().add(const LoadDepartments()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => DepartmentFormDialog.show(context),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text(
                AppStrings.addDepartment,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      body: BackgroundWrapper(
        child: BlocBuilder<DepartmentBloc, DepartmentState>(
          builder: (context, state) {
            if (state is DepartmentLoading || state is DepartmentInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            List<DepartmentEntity> departments = [];
            if (state is DepartmentsLoaded) {
              departments = state.departments;
            } else if (state is DepartmentActionSuccess) {
              departments = state.updatedDepartments;
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Section header ──────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.departments,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: _showAllNotifier,
                        builder: (context, showAll, _) {
                          return TextButton.icon(
                            onPressed: () => _showAllNotifier.value = !showAll,
                            icon: Icon(
                              showAll
                                  ? Icons.expand_less
                                  : Icons.grid_view_rounded,
                              size: 16.r,
                              color: AppColors.primary,
                            ),
                            label: Text(
                              showAll
                                  ? AppStrings.viewLess
                                  : AppStrings.viewAll,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // ── Department list ─────────────────────
                  if (departments.isEmpty)
                    _EmptyState()
                  else
                    ValueListenableBuilder<bool>(
                      valueListenable: _showAllNotifier,
                      builder: (context, showAll, _) {
                        if (!showAll) {
                          // Horizontal strip
                          return SizedBox(
                            height: widget.isAdmin ? 168.h : 138.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: departments.length,
                              itemBuilder: (context, i) => DepartmentCard(
                                department: departments[i],
                                isAdmin: widget.isAdmin,
                                onEdit: widget.isAdmin
                                    ? () => DepartmentFormDialog.show(
                                        context,
                                        existingDepartment: departments[i],
                                      )
                                    : null,
                                onDelete: widget.isAdmin
                                    ? () => _confirmDelete(
                                        context,
                                        departments[i],
                                      )
                                    : null,
                              ),
                            ),
                          );
                        } else {
                          // Full grid
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      MediaQuery.of(context).size.width > 600
                                      ? 4
                                      : 3,
                                  crossAxisSpacing: 12.w,
                                  mainAxisSpacing: 12.h,
                                  childAspectRatio: widget.isAdmin
                                      ? 0.62
                                      : 0.75,
                                ),
                            itemCount: departments.length,
                            itemBuilder: (context, i) => DepartmentCard(
                              department: departments[i],
                              isAdmin: widget.isAdmin,
                              onEdit: widget.isAdmin
                                  ? () => DepartmentFormDialog.show(
                                      context,
                                      existingDepartment: departments[i],
                                    )
                                  : null,
                              onDelete: widget.isAdmin
                                  ? () =>
                                        _confirmDelete(context, departments[i])
                                  : null,
                            ),
                          );
                        }
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, DepartmentEntity dept) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
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
              style: const TextStyle(color: AppColors.textSecondary),
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
              style: const TextStyle(
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

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 60.h),
          Icon(
            Icons.local_hospital_outlined,
            size: 64.r,
            color: AppColors.border,
          ),
          SizedBox(height: 16.h),
          Text(
            AppStrings.noDepartments,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
