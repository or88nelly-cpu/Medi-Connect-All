import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/features/patient/speciality/domain/entities/speciality_entity.dart';
import 'package:medi_connect/core/utils/dashboard_color_palette.dart';
import 'package:medi_connect/core/utils/entity_icon_mapper.dart';

class SpecialityInfoCard extends StatelessWidget {
  final SpecialityEntity speciality;

  const SpecialityInfoCard({super.key, required this.speciality});

  @override
  Widget build(BuildContext context) {
    final iconColor = DashboardColorPalette.forName(speciality.name);
    final fallbackIcon = EntityIconMapper.forSpeciality(speciality.name);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            iconColor.withValues(alpha: 0.12),
            iconColor.withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: iconColor.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 68.r,
            height: 68.r,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child:
                  speciality.imageUrl != null && speciality.imageUrl!.isNotEmpty
                  ? CustomImageView(
                      imagePath: speciality.imageUrl!,
                      width: 36.r,
                      height: 36.r,
                      color: iconColor,
                      fit: BoxFit.contain,
                    )
                  : Icon(fallbackIcon, color: iconColor, size: 36.sp),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  speciality.name,
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                if (speciality.description != null &&
                    speciality.description!.isNotEmpty) ...[
                  SizedBox(height: 6.h),
                  Text(
                    speciality.description!,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
                SizedBox(height: 10.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 6.h,
                  children: [
                    if (speciality.isSurgical)
                      const _Chip(label: 'Surgical', color: Colors.red),
                    _Chip(
                      label: '${speciality.consultationDuration} min session',
                      color: iconColor,
                    ),
                    if (speciality.defaultConsultationFee != null)
                      _Chip(
                        label:
                            '₹${speciality.defaultConsultationFee!.toStringAsFixed(0)}',
                        color: Colors.green,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
