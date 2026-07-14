import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/features/management/staff_management/presentation/bloc/department_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_drawer.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_dashboard/items/department_grid_item.dart';
import 'package:medi_connect/features/management/staff_management/domain/entities/department_entity.dart';
import 'package:medi_connect/features/management/staff_management/data/models/department_model.dart';
import 'package:medi_connect/core/functions/app_responsive.dart';

class AdminDepartmentsPage extends StatefulWidget {
  const AdminDepartmentsPage({super.key});

  @override
  State<AdminDepartmentsPage> createState() => _AdminDepartmentsPageState();
}

class _AdminDepartmentsPageState extends State<AdminDepartmentsPage> {
  bool isGridView = true;

  @override
  void initState() {
    super.initState();
    context.read<DepartmentBloc>().add(const LoadDepartments());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomScaffold(
      drawer: AdminDrawer(),
      appBarNeeded: AppResponsive.isMobile(context),
      body: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Departments",
                  style: AppTextStyles.headingMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.grid_view,
                        color: isGridView ? AppColors.primary : Colors.grey,
                      ),
                      onPressed: () => setState(() => isGridView = true),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.table_chart,
                        color: !isGridView ? AppColors.primary : Colors.grey,
                      ),
                      onPressed: () => setState(() => isGridView = false),
                    ),
                    SizedBox(width: 16.w),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Create new department
                        context.pushNamed('/admin/department/new');
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        "Add Department",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: BlocBuilder<DepartmentBloc, DepartmentState>(
                builder: (context, state) {
                  if (state is DepartmentLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DepartmentError) {
                    return Center(child: Text(state.failure.message));
                  } else if (state is DepartmentsLoaded) {
                    final departments = state.departments;

                    if (departments.isEmpty) {
                      return const Center(child: Text("No Departments Found"));
                    }

                    if (isGridView) {
                      return _buildGridView(departments, isDark);
                    } else {
                      return _buildTableView(departments, isDark);
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(List<DepartmentEntity> departments, bool isDark) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppResponsive.isMobile(context)
            ? 1
            : (AppResponsive.isTablet(context) ? 2 : 3),
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 2.5,
      ),
      itemCount: departments.length,
      itemBuilder: (context, index) {
        final dept = departments[index];
        return DepartmentGridItem(
          department: dept,
          onTap: () => context.push(
            '/departmentDetail',
            extra: DepartmentModel.fromEntity(dept),
          ),
        );
      },
    );
  }

  Widget _buildTableView(List<DepartmentEntity> departments, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            showCheckboxColumn: false,
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Description')),
              DataColumn(label: Text('Consultation')),
              DataColumn(label: Text('Created At')),
            ],
            rows: departments.map((dept) {
              return DataRow(
                onSelectChanged: (_) {
                  // context.pushNamed(RouteNames.departmentDetail, pathParameters: {'id': dept.id});
                  // Edit using click and redirect to detail page as form
                  context.pushNamed(
                    '/admin/department/edit',
                    pathParameters: {'id': dept.id},
                  );
                },
                cells: [
                  DataCell(Text(dept.id.substring(0, 6))), // Short ID
                  DataCell(Text(dept.name)),
                  DataCell(Text(dept.description ?? 'N/A')),
                  DataCell(
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: dept.consultation
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        dept.consultation ? 'Yes' : 'No',
                        style: TextStyle(
                          color: dept.consultation ? Colors.green : Colors.red,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(dept.createdAt.toString().split(' ')[0]),
                  ), // Date only
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
