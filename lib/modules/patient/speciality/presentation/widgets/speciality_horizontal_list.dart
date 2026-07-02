import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/modules/patient/speciality/domain/entities/speciality_entity.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/modules/patient/booking/presentation/pages/speciality_doctors_page.dart';

class SpecialityHorizontalList extends StatelessWidget {
  final List<SpecialityEntity> specialities;
  final String title;
  final bool isAdmin;

  const SpecialityHorizontalList({
    super.key,
    required this.specialities,
    required this.title,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: textColor,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/specialities'),
              child: Text(
                "View All",
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        if (specialities.isEmpty)
          Container(
            height: 90.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isDark ? AppColors.terminalDarkCard : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.border(context)),
            ),
            child: Text(
              "No specialties available",
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary(context),
              ),
            ),
          )
        else
          SizedBox(
            height: 100.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: specialities.length.clamp(0, 6),
              itemBuilder: (context, index) {
                final spec = specialities[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => SpecialityDoctorsPage(speciality: spec),
                      ),
                    );
                  },
                  child: Container(
                    width: 90.w,
                    margin: EdgeInsets.only(right: 12.w),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.terminalDarkCard : Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.border(context)),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 8.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40.r,
                          height: 40.r,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: CustomImageView(
                            imagePath: spec.imageUrl ?? "",
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          spec.name,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.sp,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  IconData _getIconData(String? iconName) {
    if (iconName == null) return Icons.local_hospital_outlined;
    switch (iconName.toLowerCase()) {
      case 'cardiology':
      case 'heart':
        return Icons.favorite_border;
      case 'neurology':
      case 'brain':
        return Icons.psychology_outlined;
      case 'pediatrics':
      case 'child':
        return Icons.child_care;
      case 'orthopedics':
      case 'bone':
        return Icons.accessibility_new;
      case 'dermatology':
      case 'skin':
        return Icons.clean_hands_outlined;
      case 'surgery':
        return Icons.medical_services_outlined;
      default:
        return Icons.local_hospital_outlined;
    }
  }
}
