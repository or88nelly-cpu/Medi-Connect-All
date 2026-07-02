import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class PatientPremiumTab extends StatelessWidget {
  const PatientPremiumTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              // Golden Crown Header
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.secondary, width: 2),
                ),
                child: Icon(
                  Icons.workspace_premium_outlined,
                  color: AppColors.secondary,
                  size: 48.r,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'MediConnect Premium',
                style: AppTextStyles.headingLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 24.sp,
                  color: isDark ? Colors.white : AppColors.primary,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Elevate your healthcare experience with priority booking and expert care insights.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary(context),
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 32.h),

              // Benefits List
              _buildBenefitRow(
                context,
                icon: Icons.flash_on_rounded,
                title: 'Priority Booking',
                subtitle: 'Get doctor appointments instantly without long wait times.',
              ),
              SizedBox(height: 16.h),
              _buildBenefitRow(
                context,
                icon: Icons.percent_rounded,
                title: 'Exclusive Discounts',
                subtitle: 'Save up to 20% on consultations, lab tests, and medicines.',
              ),
              SizedBox(height: 16.h),
              _buildBenefitRow(
                context,
                icon: Icons.analytics_outlined,
                title: 'Health Insights',
                subtitle: 'Get AI-driven summaries and predictions of your vitals history.',
              ),
              SizedBox(height: 16.h),
              _buildBenefitRow(
                context,
                icon: Icons.ad_units_rounded,
                title: 'Ad-free Experience',
                subtitle: 'No interruptions or banners while searching and booking.',
              ),

              SizedBox(height: 48.h),

              // Subscribe Button
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Subscription purchase flow coming soon!')),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 54.h,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF7C325), Color(0xFFE29E0D)],
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondary.withValues(alpha: 0.3),
                        blurRadius: 16.r,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Subscribe Now • ₹299/mo',
                    style: AppTextStyles.buttonLarge.copyWith(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.terminalDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24.r),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                    color: isDark ? Colors.white : AppColors.textDarkNavy,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary(context),
                    fontSize: 12.sp,
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
