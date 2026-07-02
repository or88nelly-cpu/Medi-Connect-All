import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class PatientHealthOverview extends StatelessWidget {
  const PatientHealthOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Health Overview',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 16.sp,
                color: textColor,
              ),
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vitals tracker details coming soon!')),
                );
              },
              child: Row(
                children: [
                  Text(
                    'View All',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.primary,
                    size: 14.r,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),

        // Row of Track Health Card (Left) & Vitals List (Right)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Card: "Track Your Health"
            Expanded(
              flex: 4,
              child: Container(
                height: 256.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF86E3CE), Color(0xFF5CA4A9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF5CA4A9).withValues(alpha: 0.25),
                      blurRadius: 15.r,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Track Your Health,\nStay Ahead',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 15.sp,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Monitor your vitals and get insights to stay healthier every day.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 10.5.sp,
                        height: 1.3,
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: Container(
                        width: 80.r,
                        height: 80.r,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.favorite_rounded,
                          color: Colors.white,
                          size: 40.r,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(width: 14.w),

            // Right Column: Vitals List (4 items)
            Expanded(
              flex: 6,
              child: Column(
                children: [
                  _buildVitalRow(
                    context,
                    icon: Icons.favorite_border_rounded,
                    iconColor: const Color(0xFFFF296D),
                    title: 'Heart Rate',
                    value: '72 bpm',
                    status: 'Normal',
                    time: 'Updated 1h ago',
                  ),
                  SizedBox(height: 8.h),
                  _buildVitalRow(
                    context,
                    icon: Icons.opacity_rounded,
                    iconColor: const Color(0xFF1A8CFF),
                    title: 'Blood Pressure',
                    value: '120/80 mmHg',
                    status: 'Normal',
                    time: 'Updated 2h ago',
                  ),
                  SizedBox(height: 8.h),
                  _buildVitalRow(
                    context,
                    icon: Icons.water_drop_outlined,
                    iconColor: const Color(0xFFFF9F1C),
                    title: 'Blood Sugar',
                    value: '98 mg/dL',
                    status: 'Normal',
                    time: 'Updated 1d ago',
                  ),
                  SizedBox(height: 8.h),
                  _buildVitalRow(
                    context,
                    icon: Icons.health_and_safety_outlined,
                    iconColor: const Color(0xFF2EC4B6),
                    title: 'Allergies',
                    value: 'No known allergies',
                    status: 'Updated',
                    time: '2d ago',
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVitalRow(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String status,
    required String time,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 58.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.terminalDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Row(
        children: [
          // Icon Box
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 16.r),
          ),
          SizedBox(width: 10.w),

          // Info Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 9.5.sp,
                    color: AppColors.textSecondary(context),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 11.5.sp,
                    color: isDark ? Colors.white : AppColors.textDarkNavy,
                  ),
                ),
              ],
            ),
          ),

          // Status & Time Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                status,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 9.sp,
                  color: const Color(0xFF22C55E),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                time,
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 8.sp,
                  color: AppColors.textSecondary(context),
                ),
              ),
            ],
          ),
          SizedBox(width: 4.w),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary(context).withValues(alpha: 0.5),
            size: 14.r,
          ),
        ],
      ),
    );
  }
}
