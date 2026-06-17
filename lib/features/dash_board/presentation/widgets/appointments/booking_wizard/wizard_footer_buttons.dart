import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'booking_wizard_cubit.dart';

class WizardFooterButtons extends StatelessWidget {
  final VoidCallback onSubmit;

  const WizardFooterButtons({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.watch<BookingWizardCubit>();
    final state = cubit.state;

    final canGoNext =
        (state.currentStep == 0 &&
            state.selectedPatient != null &&
            !state.isCreatingPatient) ||
        (state.currentStep == 1 && state.selectedSection != null) ||
        (state.currentStep == 2 && state.selectedDoctor != null) ||
        (state.currentStep == 3 && state.selectedSlotTime != null) ||
        (state.currentStep == 4);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left Button: Back or Cancel
        if (state.currentStep > 0)
          SizedBox(
            width: 100.w,
            height: 40.h,
            child: OutlinedButton(
              onPressed: () => cubit.previousStep(),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.border(context)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                "Back",
                style: AppTextStyles.labelMedium.copyWith(
                  color: isDark ? Colors.white70 : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        else
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppStrings.cancel,
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        // Right Button: Next or Book
        if (state.currentStep < 4)
          SizedBox(
            width: 120.w,
            height: 40.h,
            child: ElevatedButton(
              onPressed: canGoNext ? () => cubit.nextStep() : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withValues(
                  alpha: 0.3,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                AppStrings.next,
                style: AppTextStyles.labelMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        else
          SizedBox(
            width: 180.w,
            height: 40.h,
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                "Book Appointment",
                style: AppTextStyles.labelMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
