import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/modules/patient/speciality/presentation/bloc/speciality_bloc.dart';
import 'package:medi_connect/modules/patient/speciality/domain/entities/speciality_entity.dart';
import 'package:medi_connect/modules/patient/booking/presentation/pages/speciality_doctors_page.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';

class PatientSpecialitiesSection extends StatefulWidget {
  const PatientSpecialitiesSection({super.key});

  @override
  State<PatientSpecialitiesSection> createState() =>
      _PatientSpecialitiesSectionState();
}

class _PatientSpecialitiesSectionState
    extends State<PatientSpecialitiesSection> {
  @override
  void initState() {
    super.initState();
    context.read<SpecialityBloc>().add(LoadSpecialities());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Our Specialities',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 16.sp,
                color: textColor,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/specialities'),
              child: Row(
                children: [
                  Text(
                    'View All',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.primary,
                    size: 14.r,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),

        // Specialties 2x4 Grid
        BlocBuilder<SpecialityBloc, SpecialityState>(
          builder: (context, state) {
            List<SpecialityEntity> specialtiesList = [];
            if (state is SpecialitiesLoaded) {
              specialtiesList = state.specialities;
            } else if (state is SpecialityActionSuccess) {
              specialtiesList = state.updatedList;
            }

            final activeSpecs = specialtiesList
                .where((s) => s.isActive)
                .toList();
            final displayedSpecs = activeSpecs.take(7).toList();
            final itemCount = displayedSpecs.length + 1;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: itemCount,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.h,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final isViewAll = index == displayedSpecs.length;

                if (isViewAll) {
                  return GestureDetector(
                    onTap: () => context.push('/specialities'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.terminalDarkCard
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: AppColors.border(context)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10.r,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 8.h,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 44.r,
                            height: 44.r,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.grid_view_rounded,
                              color: AppColors.primary,
                              size: 20.r,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'View All',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 9.sp,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final spec = displayedSpecs[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) =>
                            SpecialityDoctorsPage(speciality: spec),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.terminalDarkCard : Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.border(context)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10.r,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 8.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Round Icon Box with CustomImageView
                        Container(
                          width: 44.r,
                          height: 44.r,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22.r),
                            child: CustomImageView(
                              imagePath: spec.imageUrl ?? "",
                              width: 28.r,
                              height: 28.r,
                              color: isDark ? AppColors.lightBlueCard : null,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        // Label text
                        Text(
                          spec.name,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 9.sp,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
