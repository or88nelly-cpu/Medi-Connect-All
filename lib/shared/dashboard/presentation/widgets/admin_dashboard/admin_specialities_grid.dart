import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/core/navigation/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/loaders/shimmer_card.dart';
import 'package:medi_connect/features/patient/speciality/presentation/bloc/speciality_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_dashboard/items/speciality_grid_item.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_dashboard/sheets/speciality_detail_sheet.dart';

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
    final state = context.read<SpecialityBloc>().state;
    if (state is! SpecialitiesLoaded) {
      context.read<SpecialityBloc>().add(LoadSpecialities());
    }
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.35,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const ShimmerGridCard(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13132B) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE8ECF4),
        ),
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(Icons.medical_services_outlined,
                        color: const Color(0xFF8B5CF6), size: 18.sp),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Specialities',
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.dashboardTextPrimary(context),
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () => context.push(RouteNames.adminSpecialities),
                icon: Icon(Icons.arrow_forward_ios_rounded,
                    size: 12.sp, color: AppColors.primary),
                label: Text(
                  'View All',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Content
          BlocBuilder<SpecialityBloc, SpecialityState>(
            builder: (context, state) {
              if (state is SpecialityLoading) {
                return _buildShimmerGrid();
              }

              if (state is SpecialityError) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Text(
                      state.failure.message,
                      style: AppTextStyles.labelMedium
                          .copyWith(color: Colors.red.shade400),
                    ),
                  ),
                );
              }

              List<dynamic> specialities = [];
              if (state is SpecialitiesLoaded) {
                specialities = state.specialities.take(6).toList();
              } else if (state is SpecialityActionSuccess) {
                specialities = state.updatedList.take(6).toList();
              }

              if (specialities.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.r),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.medical_services_outlined,
                            size: 40.sp, color: Colors.grey.shade400),
                        SizedBox(height: 8.h),
                        Text(
                          'No Specialities Found',
                          style: AppTextStyles.labelMedium
                              .copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 1.35,
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
            },
          ),
        ],
      ),
    );
  }
}
