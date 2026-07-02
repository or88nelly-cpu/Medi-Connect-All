import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class PatientPremiumBanner extends StatelessWidget {
  const PatientPremiumBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3F2B96), Color(0xFFA8C0FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3F2B96).withValues(alpha: 0.3),
            blurRadius: 15.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            // Decorative Crown Watermark
            Positioned(
              right: -20.w,
              top: -10.h,
              child: Opacity(
                opacity: 0.12,
                child: Icon(
                  Icons.workspace_premium_outlined,
                  color: Colors.white,
                  size: 160.r,
                ),
              ),
            ),

            // Banner Contents
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Golden Crown Icon
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.secondary, width: 1.5),
                        ),
                        child: const Icon(
                          Icons.workspace_premium_outlined,
                          color: AppColors.secondary,
                          size: 26,
                        ),
                      ),
                      SizedBox(width: 14.w),

                      // Title
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Go Premium for Better Care',
                              style: AppTextStyles.titleMedium.copyWith(
                                fontWeight: FontWeight.w900,
                                fontSize: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Unlock exclusive benefits and healthcare insights.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 10.5.sp,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 10.w),

                      // Golden Pill Button
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Premium subscription flow coming soon!')),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFF7C325), Color(0xFFE29E0D)],
                            ),
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 8.r,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Subscribe',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.white,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: Colors.white,
                                size: 14.r,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 18.h),
                  const Divider(color: Colors.white24, height: 1),
                  SizedBox(height: 14.h),

                  // Bottom Features Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFeatureItem(Icons.flash_on_rounded, 'Priority Booking'),
                      _buildFeatureItem(Icons.percent_rounded, 'Exclusive Discounts'),
                      _buildFeatureItem(Icons.insights_rounded, 'Health Insights'),
                      _buildFeatureItem(Icons.ad_units_rounded, 'Ad-free Experience'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.secondary, size: 14.r),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 8.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
