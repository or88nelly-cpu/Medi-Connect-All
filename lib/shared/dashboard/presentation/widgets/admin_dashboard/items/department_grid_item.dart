import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/utils/dashboard_color_palette.dart';
import 'package:medi_connect/core/utils/entity_icon_mapper.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/features/management/staff_management/domain/entities/department_entity.dart';

/// A compact grid card for a [DepartmentEntity].
/// Shows: icon/image in a colored circle + department name.
/// All colors are sourced from [AppColors] via [DashboardColorPalette].
class DepartmentGridItem extends StatelessWidget {
  final DepartmentEntity department;
  final VoidCallback onTap;

  const DepartmentGridItem({
    super.key,
    required this.department,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final iconColor = DashboardColorPalette.forName(department.name);
    final fallbackIcon = EntityIconMapper.forDepartment(department.name);

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
              color: DashboardColorPalette.borderForName(department.name),
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: DashboardColorPalette.shadowForName(
                        department.name,
                      ),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _IconCircle(
                imagePath: department.imageUrl,
                fallbackIcon: fallbackIcon,
                iconColor: iconColor,
                isDark: isDark,
              ),
              SizedBox(height: 10.h),
              Text(
                department.name,
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary(context),
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Reusable icon circle widget used by grid items.
class _IconCircle extends StatelessWidget {
  final String? imagePath;
  final IconData fallbackIcon;
  final Color iconColor;
  final bool isDark;

  const _IconCircle({
    required this.imagePath,
    required this.fallbackIcon,
    required this.iconColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.r,
      height: 60.r,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: isDark ? 0.15 : 0.10),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: imagePath != null && imagePath!.isNotEmpty
            ? CustomImageView(
                imagePath: imagePath!,
                width: 34.r,
                height: 34.r,
                fit: BoxFit.contain,
                color: iconColor,
              )
            : Icon(fallbackIcon, color: iconColor, size: 32.sp),
      ),
    );
  }
}
