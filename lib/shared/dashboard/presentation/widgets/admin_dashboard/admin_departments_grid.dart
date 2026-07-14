import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/navigation/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/features/management/staff_management/presentation/bloc/department_bloc.dart';
import 'package:medi_connect/features/management/staff_management/domain/entities/department_entity.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_dashboard/items/department_grid_item.dart';

class AdminDepartmentsGrid extends StatefulWidget {
  const AdminDepartmentsGrid({super.key});

  @override
  State<AdminDepartmentsGrid> createState() => _AdminDepartmentsGridState();
}

class _AdminDepartmentsGridState extends State<AdminDepartmentsGrid> {
  @override
  void initState() {
    super.initState();
    context.read<DepartmentBloc>().add(const LoadDepartments());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.local_hospital, color: AppColors.primary, size: 24.sp),
                  SizedBox(width: 8.w),
                  Text(
                    AppStrings.departments,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  context.pushNamed('/admin/departments'); // TODO: update routing later
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppStrings.dashboard, // Temporarily using available string for View All
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward,
                      size: 16.sp,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          BlocBuilder<DepartmentBloc, DepartmentState>(
            builder: (context, state) {
              if (state is DepartmentLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is DepartmentError) {
                return Center(child: Text(state.failure.message));
              } else if (state is DepartmentsLoaded) {
                final departments = state.departments.take(6).toList(); // Show max 6 on dashboard
                
                if (departments.isEmpty) {
                  return const Center(child: Text("No Departments Found"));
                }
                
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: departments.length,
                  itemBuilder: (context, index) {
                    final department = departments[index];
                    return DepartmentGridItem(
                      department: department,
                      isDark: isDark,
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
