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
  final bool isExpanded;
  const AdminSpecialitiesGrid({super.key, this.isExpanded = false});

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
                  Icon(Icons.hub, color: AppColors.adminPrimary, size: 24.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Specialities', // Hardcoded until AppStrings is updated
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.dashboardTextPrimary(context),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  context.pushNamed(RouteNames.adminSpecialities);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "View All",
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
                
                Widget grid = GridView.builder(
                  shrinkWrap: !widget.isExpanded,
                  physics: widget.isExpanded ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 1.6, // Adjusted for 3 columns
                  ),
                  itemCount: specialities.length,
                  itemBuilder: (context, index) {
                    final speciality = specialities[index];
                    return SpecialityGridItem(
                      speciality: speciality,
                      isDark: isDark,
                    );
                  },
                );
                
                if (widget.isExpanded) {
                  return Expanded(child: grid);
                } else {
                  return grid;
                }
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
