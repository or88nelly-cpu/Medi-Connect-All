import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';

class RegistrationProgressHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String stepTitle;
  final bool isPatientMode;

  const RegistrationProgressHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepTitle,
    this.isPatientMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final percentage = ((currentStep / totalSteps) * 100).round();

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          width: 1.w,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left column: stepper and title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isPatientMode ? "Complete Your Profile" : "Patient Registration",
                  style: AppTextStyles.headingMedium.copyWith(
                    color: AppColors.textPrimary(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Step $currentStep of $totalSteps  •  $stepTitle",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(height: 16.h),

                // Stepper Circles
                Row(
                  children: [
                    _buildStepCircle(1, currentStep >= 1, currentStep > 1),
                    _buildStepLine(currentStep > 1),
                    _buildStepCircle(2, currentStep >= 2, currentStep > 2),
                    _buildStepLine(currentStep > 2),
                    _buildStepCircle(3, currentStep >= 3, currentStep > 3),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  "$percentage% Completed",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),

          // Right column: Illustration/Image
          _buildIllustration(currentStep, isDark),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int step, bool isActive, bool isCompleted) {
    return Container(
      width: 24.r,
      height: 24.r,
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.primary
            : isActive
                ? AppColors.primary
                : const Color(0xFFE2E8F0),
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? Colors.transparent : Colors.grey.shade300,
          width: 1.w,
        ),
      ),
      child: Center(
        child: isCompleted
            ? Icon(Icons.check, color: Colors.white, size: 14.r)
            : Text(
                "$step",
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                  fontSize: 10.sp,
                ),
              ),
      ),
    );
  }

  Widget _buildStepLine(bool isCompleted) {
    return Expanded(
      child: Container(
        height: 2.h,
        color: isCompleted ? AppColors.primary : const Color(0xFFE2E8F0),
      ),
    );
  }

  Widget _buildIllustration(int step, bool isDark) {
    // Return a responsive illustration based on step
    double size = 90.r;
    
    if (step == 1) {
      // Step 1: Lady image or user profile illustration
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: CustomImageView(
          imagePath: "assets/images/lady_image.png",
          width: size,
          height: size,
          fit: BoxFit.contain,
          borderRadius: 16.r,
          errorWidget: _buildFallbackIconIllustration(Icons.person_outline, const Color(0xFFE0E7FF), AppColors.primary),
        ),
      );
    } else if (step == 2) {
      // Step 2: Clipboard checklist
      return _buildFallbackIconIllustration(
        Icons.assignment_outlined,
        isDark ? const Color(0xFF1E293B) : const Color(0xFFECFDF5),
        AppColors.success,
      );
    } else {
      // Step 3: Review / ID Card
      return _buildFallbackIconIllustration(
        Icons.badge_outlined,
        isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
        AppColors.info,
      );
    }
  }

  Widget _buildFallbackIconIllustration(IconData icon, Color bg, Color tint) {
    double size = 80.r;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: tint.withValues(alpha: 0.15),
            blurRadius: 10.r,
            spreadRadius: 2.r,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          color: tint,
          size: size * 0.5,
        ),
      ),
    );
  }
}
