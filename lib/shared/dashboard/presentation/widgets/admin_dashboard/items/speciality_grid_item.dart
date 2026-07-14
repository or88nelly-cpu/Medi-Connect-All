import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/navigation/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/features/patient/speciality/domain/entities/speciality_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SpecialityGridItem extends StatelessWidget {
  final SpecialityEntity speciality;
  final bool isDark;

  const SpecialityGridItem({
    super.key,
    required this.speciality,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(RouteNames.adminSpecialityEdit, pathParameters: {'id': speciality.id});
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
              child: speciality.imageUrl != null && speciality.imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: speciality.imageUrl!,
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
              speciality.name,
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
              "12 Doctors • 28 Today", // Mock data for now
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
    IconData iconData = Icons.medical_services;
    Color iconColor = AppColors.primary;
    
    final nameLower = speciality.name.toLowerCase();
    if (nameLower.contains("cardiology")) {
      iconData = Icons.favorite;
      iconColor = const Color(0xFFEF4444); // Red
    } else if (nameLower.contains("neurology")) {
      iconData = Icons.psychology;
      iconColor = const Color(0xFFA855F7); // Purple
    } else if (nameLower.contains("orthopedics")) {
      iconData = Icons.accessible;
      iconColor = const Color(0xFF3B82F6); // Blue
    } else if (nameLower.contains("pediatrics")) {
      iconData = Icons.child_care;
      iconColor = const Color(0xFFEC4899); // Pink
    } else if (nameLower.contains("ent")) {
      iconData = Icons.hearing;
      iconColor = const Color(0xFF14B8A6); // Teal
    } else if (nameLower.contains("dermatology")) {
      iconData = Icons.face;
      iconColor = const Color(0xFFEAB308); // Yellow
    }

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 36.sp, // Matching DepartmentGridItem
      ),
    );
  }
}
