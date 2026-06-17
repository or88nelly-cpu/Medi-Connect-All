import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'booking_wizard_cubit.dart';

class StepIndicator extends StatelessWidget {
  const StepIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentStep = context.watch<BookingWizardCubit>().state.currentStep;

    final steps = [
      {"icon": Icons.person, "label": "Patient"},
      {"icon": Icons.category, "label": "Specialty"},
      {"icon": Icons.medical_services, "label": "Doctor"},
      {"icon": Icons.access_time, "label": "Slot"},
      {"icon": Icons.rate_review, "label": "Confirm"},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(steps.length, (idx) {
        final isCompleted = currentStep > idx;
        final isActive = currentStep == idx;
        final iconColor = isActive
            ? Colors.white
            : (isCompleted
                  ? AppColors.success
                  : (AppColors.textSecondary(context).withValues(alpha: 0.5)));
        final circleBg = isActive
            ? AppColors.primary
            : (isCompleted
                  ? AppColors.success.withValues(alpha: 0.15)
                  : Colors.transparent);
        final borderColor = isActive
            ? AppColors.primary
            : (isCompleted ? AppColors.success : (AppColors.border(context)));

        return Expanded(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 36.r,
                    height: 36.r,
                    decoration: BoxDecoration(
                      color: circleBg,
                      shape: BoxShape.circle,
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(
                              Icons.check,
                              color: AppColors.success,
                              size: 18,
                            )
                          : Icon(
                              steps[idx]['icon'] as IconData,
                              color: iconColor,
                              size: 16,
                            ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    steps[idx]['label'] as String,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 10.sp,
                      fontWeight: isActive
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isActive
                          ? AppColors.primary
                          : (isDark
                                ? Colors.white70
                                : AppColors.textSecondary(context)),
                    ),
                  ),
                ],
              ),
              if (idx < steps.length - 1)
                Expanded(
                  child: Container(
                    height: 2.h,
                    margin: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 12.h,
                    ),
                    color: isCompleted
                        ? AppColors.success
                        : (AppColors.border(context)),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
