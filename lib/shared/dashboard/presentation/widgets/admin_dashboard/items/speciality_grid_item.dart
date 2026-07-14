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
        context.pushNamed(RouteNames.specialities);
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
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.medical_services,
        color: AppColors.primary,
        size: 32.sp,
      ),
    );
  }
}
