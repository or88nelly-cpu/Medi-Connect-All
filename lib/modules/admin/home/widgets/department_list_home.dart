import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/department/domain/entities/department_entity.dart';
import 'package:medi_connect/features/department/presentation/bloc/department_bloc.dart';
import 'admin_department_card.dart';
import 'department_list_shimmer.dart';

class DepartmentListHome extends StatelessWidget {
  const DepartmentListHome({super.key});


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = MediaQuery.of(context).size.width > 950;

    final margin = isDesktop
        ? EdgeInsets.only(left: 58.r)
        : EdgeInsets.symmetric(horizontal: 16.r);

    return BlocBuilder<DepartmentBloc, DepartmentState>(
      builder: (context, state) {
        final bool isLoading = state is DepartmentLoading;

        final List<DepartmentEntity> loadedList = state is DepartmentsLoaded
            ? state.departments
            : state is DepartmentActionSuccess
            ? (state.updatedDepartments)
            : [];

        // Build the exactly 24 ordered list with Supabase bindings & Fallbacks
      

     
        return LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;
            final int crossAxisCount = _getResponsiveCrossAxisCount(width);

            return Container(
              margin: margin,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(28.r),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.04)
                      : Colors.black.withValues(alpha: 0.03),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.02),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.grid_view_outlined,
                            size: 24.r,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F2C59),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            AppStrings.departments,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontSize: 18.sp,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F2C59),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      // Decorative plus sign as seen in mockup
                      Icon(
                        Icons.add_rounded,
                        size: 24.r,
                        color: AppColors.primary.withValues(
                          alpha: isDark ? 0.3 : 0.15,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.r),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: isLoading ? 24 : loadedList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                      childAspectRatio:
                          1.9, // Squared aspect ratio matches mockup
                    ),
                    itemBuilder: (_, index) {
                      if (isLoading) {
                        return const DepartmentCardShimmer();
                      }

                      return AdminDepartmentCard(
                        department: loadedList[index],
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

  int _getResponsiveCrossAxisCount(double width) {
    if (width > 1200) {
      return 6;
    } else if (width > 900) {
      return 5;
    } else if (width > 700) {
      return 4;
    } else if (width > 500) {
      return 3;
    } else {
      return 2;
    }
  }
}
