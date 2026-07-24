import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/features/admin/home/widgets/admin_department_card.dart';
import 'package:medi_connect/features/admin/home/widgets/department_list_shimmer.dart';
import 'package:medi_connect/features/admin/staff_management/domain/entities/department_entity.dart';

/// Grid view implementation displaying department cards.
class DepartmentGridView extends StatelessWidget {
  final List<DepartmentEntity> departments;
  final bool isLoading;

  const DepartmentGridView({
    super.key,
    required this.departments,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final int crossAxisCount = _getResponsiveCrossAxisCount(width);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: isLoading ? 12 : departments.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: width < 700 ? 1.1 : 1.8,
          ),
          itemBuilder: (context, index) {
            if (isLoading) {
              return const DepartmentCardShimmer();
            }
            return AdminDepartmentCard(department: departments[index]);
          },
        );
      },
    );
  }

  int _getResponsiveCrossAxisCount(double width) {
    if (width > 1200) {
      return 6;
    } else if (width > 900) {
      return 4;
    } else if (width > 600) {
      return 3;
    } else {
      return 2;
    }
  }
}
