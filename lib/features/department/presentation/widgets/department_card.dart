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
  final Color? color;

  const DepartmentCard({
    super.key,
    required this.department,
    this.isAdmin = false,
    this.onEdit,
    this.onDelete,
    this.color,

    this.width,
    this.isHorizontal = false,
    required this.isSection,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(
        isSection ? RouteNames.sectionDetail : RouteNames.departmentDetail,
        extra: department,
      ),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border(context)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageView(
              imagePath: department.imageUrl ?? '',
              width: 62.r,
              height: 62.r,
            ),
            Spacer(),
            Text(
              department.name,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 13.sp),
            ),
          ],
        ),
      ),
    );
  }
}
