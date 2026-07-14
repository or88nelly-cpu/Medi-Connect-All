import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/navigation/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/features/management/staff_management/domain/entities/department_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DepartmentGridItem extends StatelessWidget {
  final DepartmentEntity department;
  final bool isDark;

  const DepartmentGridItem({
    super.key,
    required this.department,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(RouteNames.adminDepartmentEdit, pathParameters: {'id': department.id});
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.border(context)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: department.imageUrl != null && department.imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: department.imageUrl!,
                      fit: BoxFit.contain,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          _buildFallbackIcon(),
                    )
                  : _buildFallbackIcon(),
            ),
            SizedBox(height: 12.h),
            Text(
              department.name,
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Text(
              "24 Staff • 16 Beds", // Mock data for now since totalDoctors is not in entity
              style: AppTextStyles.labelSmall.copyWith(
                color: isDark ? Colors.white54 : Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackIcon() {
    IconData iconData = Icons.local_hospital;
    Color iconColor = AppColors.primary;
    
    final nameLower = department.name.toLowerCase();
    if (nameLower.contains("emergency")) {
      iconData = Icons.emergency;
      iconColor = const Color(0xFFEF4444); // Red
    } else if (nameLower.contains("laboratory")) {
      iconData = Icons.science;
      iconColor = const Color(0xFF3B82F6); // Blue
    } else if (nameLower.contains("pharmacy")) {
      iconData = Icons.medication;
      iconColor = const Color(0xFF22C55E); // Green
    } else if (nameLower.contains("radiology")) {
      iconData = Icons.coronavirus; // Closest to skeleton/xray
      iconColor = const Color(0xFFA855F7); // Purple
    } else if (nameLower.contains("icu")) {
      iconData = Icons.monitor_heart;
      iconColor = const Color(0xFF06B6D4); // Cyan
    } else if (nameLower.contains("nursing")) {
      iconData = Icons.person; // Closest to nurse
      iconColor = const Color(0xFFF97316); // Orange
    }

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        shape: BoxShape.circle, // Or BoxShape.rectangle with border radius if we wanted it squarish
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 36.sp, // Larger icon size to match design
      ),
    );
  }
}
