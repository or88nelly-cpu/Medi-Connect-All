import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

class PatientHospitalCard extends StatelessWidget {
  const PatientHospitalCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final skyGradient = isDark 
        ? const [Color(0xFF16233B), Color(0xFF0C1424)]
        : const [Color(0xFFDBECFF), Color(0xFFEDF5FF)];

    final buildingBg = isDark ? Color(0xFF09121F) : Colors.white;

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Stack(
        children: [
          // Sky background
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: skyGradient,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          // Hospital building (simplified icon block)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: buildingBg,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: AppColors.border(context),
                    ),
                  ),
                  child: Icon(
                    Icons.local_hospital_rounded,
                    color: AppColors.primary,
                    size: 22.r,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'HOSPITAL',
                  style: TextStyle(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary(context),
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
