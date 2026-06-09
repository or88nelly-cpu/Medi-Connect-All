import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
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
  final VoidCallback? onTap;

  const DepartmentCard({
    super.key,
    required this.department,
    this.isAdmin = false,
    this.onEdit,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110.w,
        margin: EdgeInsets.only(right: 12.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Image ──────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
              child:
                  department.imageUrl != null && department.imageUrl!.isNotEmpty
                  ? CustomImageView(
                      imagePath: department.imageUrl!,
                      width: 110.w,
                      height: 76.h,
                      fit: BoxFit.cover,
                    )
                  : _DefaultDepartmentImage(name: department.name),
            ),

            // ── Name ───────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
              child: Text(
                department.name,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 11.sp,
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // ── Admin actions ──────────────────────────────
            if (isAdmin)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(14.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ActionButton(
                      icon: Icons.edit_outlined,
                      color: AppColors.primary,
                      tooltip: 'Edit',
                      onTap: onEdit,
                    ),
                    Container(width: 1, height: 24.h, color: AppColors.border),
                    _ActionButton(
                      icon: Icons.delete_outline,
                      color: AppColors.error,
                      tooltip: 'Delete',
                      onTap: onDelete,
                    ),
                  ],
                ),
              ),
          ],
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
      width: 110,
      height: 76,
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          child: Icon(icon, size: 16.r, color: color),
        ),
      ),
    );
  }
}
