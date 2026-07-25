import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

/// Hospital building illustration used in the header banner.
class AdminHeaderArtwork extends StatelessWidget {
  const AdminHeaderArtwork({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190.w,
      height: 155.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.07),
            AppColors.controlCenterPurple.withValues(alpha: 0.13),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 10,
            right: 14,
            child: _Dot(
              size: 36.r,
              color: AppColors.primary.withValues(alpha: 0.08),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 14,
            child: _Dot(
              size: 22.r,
              color: AppColors.controlCenterPurple.withValues(alpha: 0.1),
            ),
          ),
          Icon(
            Icons.local_hospital_rounded,
            size: 70.r,
            color: AppColors.primary.withValues(alpha: 0.65),
          ),
          Positioned(
            top: 14,
            child: Container(
              padding: EdgeInsets.all(5.r),
              decoration: BoxDecoration(
                color: AppColors.badgeRed,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.badgeRed.withValues(alpha: 0.45),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Icon(Icons.add_rounded, size: 12.r, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final double size;
  final Color color;
  const _Dot({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}
