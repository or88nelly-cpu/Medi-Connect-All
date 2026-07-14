import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/navigation/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/features/patient/speciality/presentation/bloc/speciality_bloc.dart';
import 'package:medi_connect/features/patient/speciality/domain/entities/speciality_entity.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_dashboard/items/speciality_grid_item.dart';

class AdminSpecialitiesGrid extends StatefulWidget {
  const AdminSpecialitiesGrid({super.key});

  @override
  State<AdminSpecialitiesGrid> createState() => _AdminSpecialitiesGridState();
}

class _AdminSpecialitiesGridState extends State<AdminSpecialitiesGrid> {
  @override
  void initState() {
    super.initState();
    context.read<SpecialityBloc>().add(LoadSpecialities());
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
                  Icon(Icons.medical_services, color: AppColors.primary, size: 24.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Specialities', // Hardcoded until AppStrings is updated
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  context.pushNamed('/admin/specialities');
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppStrings.dashboard, // Temporarily using dashboard string
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
          BlocBuilder<SpecialityBloc, SpecialityState>(
            builder: (context, state) {
              if (state is SpecialityLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SpecialityError) {
                return Center(child: Text(state.failure.message));
              } else if (state is SpecialitiesLoaded) {
                final specialities = state.specialities.take(6).toList(); // Show max 6
                
                if (specialities.isEmpty) {
                  return const Center(child: Text("No Specialities Found"));
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
                  itemCount: specialities.length,
                  itemBuilder: (context, index) {
                    final spec = specialities[index];
                    return SpecialityGridItem(
                      speciality: spec,
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
