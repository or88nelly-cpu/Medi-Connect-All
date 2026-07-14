import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/navigation/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/features/patient/speciality/presentation/bloc/speciality_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_drawer.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_dashboard/items/speciality_grid_item.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_dashboard/sheets/speciality_detail_sheet.dart';
import 'package:medi_connect/features/patient/speciality/domain/entities/speciality_entity.dart';
import 'package:medi_connect/core/functions/app_responsive.dart';

class AdminSpecialitiesPage extends StatefulWidget {
  const AdminSpecialitiesPage({super.key});

  @override
  State<AdminSpecialitiesPage> createState() => _AdminSpecialitiesPageState();
}

class _AdminSpecialitiesPageState extends State<AdminSpecialitiesPage> {
  bool isGridView = true;

  @override
  void initState() {
    super.initState();
    context.read<SpecialityBloc>().add(LoadSpecialities());
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
                  "Specialities",
                  style: AppTextStyles.headingMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.grid_view, color: isGridView ? AppColors.primary : Colors.grey),
                      onPressed: () => setState(() => isGridView = true),
                    ),
                    IconButton(
                      icon: Icon(Icons.table_chart, color: !isGridView ? AppColors.primary : Colors.grey),
                      onPressed: () => setState(() => isGridView = false),
                    ),
                    SizedBox(width: 16.w),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.pushNamed('/admin/speciality/new');
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text("Add Speciality", style: TextStyle(color: Colors.white)),
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
              child: BlocBuilder<SpecialityBloc, SpecialityState>(
                builder: (context, state) {
                  if (state is SpecialityLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SpecialityError) {
                    return Center(child: Text(state.failure.message));
                  } else if (state is SpecialitiesLoaded) {
                    final specialities = state.specialities;

                    if (specialities.isEmpty) {
                      return const Center(child: Text("No Specialities Found"));
                    }

                    if (isGridView) {
                      return _buildGridView(specialities, isDark);
                    } else {
                      return _buildTableView(specialities, isDark);
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

  Widget _buildGridView(List<SpecialityEntity> specialities, bool isDark) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppResponsive.isMobile(context) ? 1 : (AppResponsive.isTablet(context) ? 2 : 3),
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 2.5,
      ),
      itemCount: specialities.length,
      itemBuilder: (context, index) {
        final sp = specialities[index];
        return SpecialityGridItem(
          speciality: sp,
          onTap: () => SpecialityDetailSheet.show(context, sp),
        );
      },
    );
  }

  Widget _buildTableView(List<SpecialityEntity> specialities, bool isDark) {
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
              DataColumn(label: Text('Code')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Fee')),
              DataColumn(label: Text('Surgical')),
              DataColumn(label: Text('Status')),
            ],
            rows: specialities.map((spec) {
              return DataRow(
                onSelectChanged: (_) {
                  context.pushNamed('/admin/speciality/edit', pathParameters: {'id': spec.id});
                },
                cells: [
                  DataCell(Text(spec.id.substring(0, 6))),
                  DataCell(Text(spec.specialityCode)),
                  DataCell(Text(spec.name)),
                  DataCell(Text(spec.defaultConsultationFee?.toString() ?? 'N/A')),
                  DataCell(Text(spec.isSurgical ? 'Yes' : 'No')),
                  DataCell(
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: spec.isActive ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        spec.isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          color: spec.isActive ? Colors.green : Colors.red,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
