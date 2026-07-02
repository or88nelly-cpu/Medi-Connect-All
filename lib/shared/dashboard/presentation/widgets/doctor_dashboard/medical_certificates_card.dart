import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class MedicalCertificatesCard extends StatelessWidget {
  final String count;
  final VoidCallback onViewAllTap;

  const MedicalCertificatesCard({
    super.key,
    required this.count,
    required this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0EA5E9),
            Color(0xFF0D9488),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D9488).withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.assignment_outlined,
                  color: Colors.white,
                  size: 18.r,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  "Medical Certificates",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.bold,
                    fontSize: 11.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            count,
            style: AppTextStyles.headingLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 28.sp,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            "Certificates Issued",
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 10.sp,
            ),
          ),
          SizedBox(height: 12.h),
          InkWell(
            onTap: onViewAllTap,
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "View All",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 8.r,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
