import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

/// Generic "Coming Soon" page used for features not yet fully implemented.
class PlaceholderFeaturePage extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Color> gradientColors;
  final String description;

  const PlaceholderFeaturePage({
    super.key,
    required this.title,
    required this.icon,
    required this.gradientColors,
    this.description = 'This feature is coming soon. Stay tuned for updates!',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary(context),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          title,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary(context),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated icon container
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (context, value, child) =>
                    Transform.scale(scale: value, child: child),
                child: Container(
                  width: 110.r,
                  height: 110.r,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28.r),
                    boxShadow: [
                      BoxShadow(
                        color: gradientColors.first.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 54.r),
                ),
              ),
              SizedBox(height: 32.h),
              Text(
                title,
                style: AppTextStyles.headingSmall.copyWith(
                  color: AppColors.textPrimary(context),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                description,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary(context),
                  height: 1.6,
                ),
              ),
              SizedBox(height: 40.h),
              // "Coming Soon" pill
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      gradientColors.first.withValues(alpha: 0.15),
                      gradientColors.last.withValues(alpha: 0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(50.r),
                  border: Border.all(
                    color: gradientColors.first.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.construction_rounded,
                      color: gradientColors.first,
                      size: 18.r,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Coming Soon',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: gradientColors.first,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              TextButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back_rounded,
                  size: 16.r,
                  color: AppColors.textSecondary(context),
                ),
                label: Text(
                  'Go Back',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
