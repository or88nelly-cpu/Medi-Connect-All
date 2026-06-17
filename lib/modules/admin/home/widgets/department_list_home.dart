import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/features/department/domain/entities/department_entity.dart';
import 'package:medi_connect/features/department/presentation/bloc/department_bloc.dart';
import 'package:medi_connect/features/department/presentation/widgets/department_card.dart';
import 'package:medi_connect/modules/admin/home/widgets/department_list_shimmer.dart';

/// A horizontal scrollable list of department cards displayed on any dashboard.
/// Accepts an optional [isAdmin] flag to show admin controls.
class DepartmentListHome extends StatelessWidget {
  const DepartmentListHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DepartmentBloc, DepartmentState>(
      builder: (context, state) {
        bool isLoading = state is DepartmentLoading;

        final List<DepartmentEntity> departments = state is DepartmentsLoaded
            ? state.departments
            : state is DepartmentActionSuccess
            ? (state.updatedDepartments)
            : [];
        return LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = _getCrossAxisCount(constraints.maxWidth);

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: isLoading ? 18 : departments.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16.r,
                mainAxisSpacing: 16.r,
                childAspectRatio: 1.15,
              ),
              itemBuilder: (_, index) {
                if (isLoading) {
                  return const DepartmentCardShimmer();
                }

                return DepartmentCard(
                  department: departments[index],
                  isSection: false,
                  isAdmin: false,
                  isHorizontal: false,
                );
              },
            );
          },
        );
      },
    );
  }

  int _getCrossAxisCount(double width) {
    if (width >= 1400) return 8;
    if (width >= 1100) return 6;
    if (width >= 800) return 4;

    return 3;
  }
}
