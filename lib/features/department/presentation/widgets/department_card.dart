import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/router/route_names.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/department/domain/entities/department_entity.dart';

/// A single department card shown in the horizontal list.
/// Shows a [CustomImageView] with the department image (or a gradient icon fallback),
/// the department name, and — for admin — edit / delete action buttons.
class DepartmentCard extends StatelessWidget {
  final DepartmentEntity department;
  final bool isAdmin;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  final double? width;
  final bool isHorizontal;
  final bool isSection;

  const DepartmentCard({
    super.key,
    required this.department,
    this.isAdmin = false,
    this.onEdit,
    this.onDelete,

    this.width,
    this.isHorizontal = false,
    required this.isSection,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        isSection ? RouteNames.sectionDetail : RouteNames.departmentDetail,
        extra: department,
      ),
      child: Container(
        width: width ?? 80.r,
        //height: width ?? 80.r,
        padding: isHorizontal ? null : EdgeInsets.symmetric(horizontal: 8.r),
        margin: EdgeInsets.only(right: isHorizontal ? 10.w : 0),
        decoration: isHorizontal
            ? null
            : BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.textSecondary.withValues(alpha: 0.1),
                ),
              ),
        // padding: EdgeInsets.all(12.r),
        child: Center(
          child: Column(
            children: [
              Spacer(),
              Column(
                children: [
                  department.imageUrl != null && department.imageUrl!.isNotEmpty
                      ? CustomImageView(
                          imagePath: department.imageUrl!,
                          width: 40.r,
                          height: 40.r,
                          fit: BoxFit.cover,
                        )
                      : _DefaultDepartmentImage(name: department.name),
                  Text(
                    department.name,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: isAdmin ? 11.sp : 8.sp,
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Spacer(),
              // if (isAdmin)
              //   Row(
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     children: [
              //       _ActionButton(
              //         icon: Icons.edit_outlined,
              //         color: AppColors.primary,
              //         tooltip: 'Edit',
              //         onTap: onEdit,
              //       ),
              //       Spacer(),
              //       _ActionButton(
              //         icon: Icons.delete_outline,
              //         color: AppColors.error,
              //         tooltip: 'Delete',
              //         onTap: onDelete,
              //       ),
              //     ],
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}

// Gradient icon fallback when no image URL is provided.
class _DefaultDepartmentImage extends StatelessWidget {
  final String name;

  const _DefaultDepartmentImage({required this.name});

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'D';
    return Container(
      width: 50.r,
      height: 50.r,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          color: Colors.white,
          fontSize: 28.sp,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6.r),
        child: Container(
          margin: EdgeInsets.only(bottom: 3.r),
          padding: EdgeInsets.symmetric(horizontal: 3.r, vertical: 3.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            color: color.withAlpha(25),
          ),
          child: Icon(icon, size: 16.r, color: color),
        ),
      ),
    );
  }
}
