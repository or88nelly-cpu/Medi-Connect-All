import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/features/admin/department_details/presentation/widgets/department_grid_card.dart';
import 'package:medi_connect/features/admin/staff_management/domain/entities/department_entity.dart';

/// Responsive grid of department cards — 6 col desktop, scales down.
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
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, box) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: departments.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _cols(box.maxWidth),
            crossAxisSpacing: 12.r,
            mainAxisSpacing: 12.r,
            childAspectRatio: 1.65, // compact portrait card
          ),
          itemBuilder: (context, i) => DepartmentGridCard(
            department: departments[i],
            width: getCellWidth(box.maxWidth),
            onTap: () {
              context.push("/departmentDetail", extra: departments[i]);
            },
            height: getHeight(box.maxWidth),
          ),
        );
      },
    );
  }

  int _cols(double w) {
    if (w > 1100) return 6;
    if (w > 850) return 5;
    if (w > 650) return 4;
    if (w > 480) return 3;
    return 2;
  }

  double getHeight(double w) {
    double cellWidth = getCellWidth(w);
    return cellWidth / 1.65;
  }

  double getCellWidth(double w) {
    final column = _cols(w);
    final double cellWidth = (w - ((column + 1) * 12.r)) / column;

    return cellWidth;
  }
}
