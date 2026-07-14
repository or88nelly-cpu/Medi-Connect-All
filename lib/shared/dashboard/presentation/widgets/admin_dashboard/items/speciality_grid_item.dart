import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/utils/dashboard_color_palette.dart';
import 'package:medi_connect/core/utils/entity_icon_mapper.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/features/patient/speciality/domain/entities/speciality_entity.dart';

/// A compact grid card for a [SpecialityEntity].
/// Shows: icon/image in a colored circle + name + optional description.
/// All colors are sourced from [AppColors] via [DashboardColorPalette].
class SpecialityGridItem extends StatelessWidget {
  final SpecialityEntity speciality;
  final VoidCallback onTap;

  const SpecialityGridItem({
    super.key,
    required this.speciality,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final iconColor = DashboardColorPalette.forName(speciality.name);
    final fallbackIcon = EntityIconMapper.forSpeciality(speciality.name);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColors.card(context),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: DashboardColorPalette.borderForName(speciality.name),
            ),
            boxShadow: isDark ? null : [
              BoxShadow(
                color: DashboardColorPalette.shadowForName(speciality.name),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _SpecialityIconCircle(
                imagePath: speciality.imageUrl,
                fallbackIcon: fallbackIcon,
                iconColor: iconColor,
                isDark: isDark,
              ),
              SizedBox(height: 8.h),
              Text(
                speciality.name,
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary(context),
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              if (speciality.description != null &&
                  speciality.description!.isNotEmpty) ...[
                SizedBox(height: 3.h),
                Text(
                  speciality.description!,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary(context),
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SpecialityIconCircle extends StatelessWidget {
  final String? imagePath;
  final IconData fallbackIcon;
  final Color iconColor;
  final bool isDark;

  const _SpecialityIconCircle({
    required this.imagePath,
    required this.fallbackIcon,
    required this.iconColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.r,
      height: 48.r,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: isDark ? 0.15 : 0.10),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: imagePath != null && imagePath!.isNotEmpty
            ? CustomImageView(
                imagePath: imagePath!,
                width: 28.r,
                height: 28.r,
                fit: BoxFit.contain,
                color: iconColor,
              )
            : Icon(fallbackIcon, color: iconColor, size: 26.sp),
      ),
    );
  }
}
