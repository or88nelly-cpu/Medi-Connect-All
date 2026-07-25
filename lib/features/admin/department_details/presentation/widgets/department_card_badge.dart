import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/features/admin/department_details/presentation/widgets/department_icon_mapper.dart';
import 'package:medi_connect/features/admin/staff_management/domain/entities/department_entity.dart';

/// Gradient icon badge for a department card.
/// Shows [CustomImageView] when imageUrl is present, icon fallback otherwise.
class DepartmentCardBadge extends StatelessWidget {
  final DepartmentEntity department;
  final double height;

  const DepartmentCardBadge({
    super.key,
    required this.department,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    log("height $height");
    return SizedBox(
      width: height,
      height: height,

      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: department.imageUrl != null && department.imageUrl!.isNotEmpty
            ? CustomImageView(
                imagePath: department.imageUrl!,
                width: height,
                height: height,
                color: Colors.white,
                fit: BoxFit.cover,
                errorWidget: _FallbackIcon(
                  name: department.name,
                  height: height,
                ),
              )
            : _FallbackIcon(name: department.name, height: height),
      ),
    );
  }
}

class _FallbackIcon extends StatelessWidget {
  final String name;
  final double height;
  const _FallbackIcon({required this.name, required this.height});

  @override
  Widget build(BuildContext context) => Center(
    child: Icon(
      DepartmentIconMapper.fromName(name),
      size: height * 0.4,
      color: Colors.white,
    ),
  );
}
