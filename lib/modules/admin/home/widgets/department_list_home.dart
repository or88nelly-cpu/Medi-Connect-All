import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
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
            final (crossAxisCount, itemGap) = _getCrossAxisCount(1364.w);

            return Container(
              width: 1408.w,
              margin: EdgeInsets.only(left: 58.r),
              decoration: BoxDecoration(
                color: AppColors.card(context),
                borderRadius: BorderRadius.circular(28.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.grid_view_outlined,
                        size: 24.r,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        AppStrings.departments,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontSize: 18.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.r),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: isLoading ? 18 : departments.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16.h,
                      mainAxisSpacing: 16.w,
                      childAspectRatio: 1.9,
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
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  (int crossAxisCount, double itemGap) _getCrossAxisCount(double width) {
    double itemWidth = 212;
    int crossAxisCount = (width ~/ itemWidth);
    double itemGap =
        ((width - (crossAxisCount * itemWidth)) / (crossAxisCount - 1));
    return (crossAxisCount, itemGap);
  }
}
