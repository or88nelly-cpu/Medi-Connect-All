import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/features/department/presentation/bloc/department_bloc.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_event.dart';
import 'booking_wizard_cubit.dart';

class SpecialtyStep extends StatelessWidget {
  const SpecialtyStep({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.watch<BookingWizardCubit>();
    final state = cubit.state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Text(
            "Select Clinic Specialty",
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<DepartmentBloc, DepartmentState>(
            builder: (context, deptState) {
              if (deptState is DepartmentLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (deptState is DepartmentError) {
                return Center(
                  child: Text(
                    "Error loading departments: ${deptState.failure}",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                );
              }
              if (deptState is DepartmentsLoaded) {
                final departments = deptState.sections;
                if (departments.isEmpty) {
                  return Center(
                    child: Text(
                      "No specialties available.",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark
                            ? Colors.white54
                            : AppColors.textSecondary,
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                    childAspectRatio: 2.2,
                  ),
                  itemCount: departments.length,
                  itemBuilder: (ctx, idx) {
                    final dept = departments[idx];
                    final isSelected = state.selectedSection?.id == dept.id;

                    return GestureDetector(
                      onTap: () {
                        cubit.selectSection(dept);
                        context.read<DoctorStaffBloc>().add(
                          LoadDoctorStaff(dept.name),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.08)
                              : (isDark
                                    ? AppColors.terminalDarkBg
                                    : Colors.grey[50]),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : (isDark
                                      ? AppColors.terminalDarkBorder
                                      : AppColors.border),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44.r,
                              height: 44.r,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withValues(alpha: 0.15)
                                    : (isDark
                                          ? AppColors.terminalDarkBorder
                                          : Colors.grey[200]),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child:
                                    dept.imageUrl != null &&
                                        dept.imageUrl!.trim().isNotEmpty
                                    ? CustomImageView(
                                        imagePath: dept.imageUrl!.trim(),
                                        fit: BoxFit.cover,
                                      )
                                    : Icon(
                                        Icons.local_hospital,
                                        color: isSelected
                                            ? AppColors.primary
                                            : Colors.grey,
                                        size: 24.r,
                                      ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    dept.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? AppColors.primary
                                          : (isDark
                                                ? Colors.white
                                                : AppColors.textPrimary),
                                    ),
                                  ),
                                  if (dept.description != null &&
                                      dept.description!.isNotEmpty) ...[
                                    SizedBox(height: 2.h),
                                    Text(
                                      dept.description!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        fontSize: 10.sp,
                                        color: isDark
                                            ? Colors.white38
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
