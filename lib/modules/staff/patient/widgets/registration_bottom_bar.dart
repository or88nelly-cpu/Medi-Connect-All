import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/bloc/patient_registration_bloc.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/bloc/patient_registration_event.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/bloc/patient_registration_state.dart';

/// Bottom navigation bar for the patient registration/onboarding wizard.
///
/// Calls [onNextPressed] when the primary action button is tapped —
/// the parent page is responsible for form validation before dispatching
/// [StepNextRequested] or [SubmitFormEvent] / [SubmitProfileUpdateEvent].
class RegistrationBottomBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onNextPressed;

  const RegistrationBottomBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientRegistrationBloc, PatientRegistrationState>(
      buildWhen: (prev, curr) =>
          prev.status != curr.status || prev.currentStep != curr.currentStep,
      builder: (context, state) {
        final isLoading =
            state.status == PatientRegistrationStatus.loading;
        final isLastStep = currentStep >= totalSteps;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: AppColors.card(context),
            border: Border(
              top: BorderSide(color: AppColors.border(context), width: 1.w),
            ),
          ),
          child: Row(
            children: [
              // Back button — shown on steps 2+
              if (currentStep > 1) ...[
                Expanded(child: _buildBackButton(context)),
                SizedBox(width: 12.w),
              ],

              // Skip for Now button — shown in patient self-onboarding mode on steps 1 and 2
              if (state.isPatientMode && currentStep < totalSteps) ...[
                Expanded(child: _buildSkipButton(context)),
                SizedBox(width: 12.w),
              ],

              // Primary action button
              Expanded(
                flex: currentStep > 1 ? 2 : 1,
                child: _buildPrimaryButton(
                  context,
                  isLoading: isLoading,
                  label: isLastStep
                      ? AppStrings.confirm
                      : AppStrings.next,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSkipButton(BuildContext context) {
    return TextButton(
      onPressed: () =>
          context.read<PatientRegistrationBloc>().add(const SkipOnboardingRequested()),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(color: Colors.grey.shade400, width: 1.w),
        ),
      ),
      child: Text(
        "Skip for Now",
        style: AppTextStyles.buttonMedium.copyWith(
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () =>
          context.read<PatientRegistrationBloc>().add(const StepBackRequested()),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        padding: EdgeInsets.symmetric(vertical: 14.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Text(
        AppStrings.back,
        style: AppTextStyles.buttonMedium.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12.sp,
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(
    BuildContext context, {
    required bool isLoading,
    required String label,
  }) {
    return ElevatedButton(
      onPressed: isLoading ? null : onNextPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
        padding: EdgeInsets.symmetric(vertical: 14.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        elevation: 0,
      ),
      child: isLoading
          ? SizedBox(
              width: 18.r,
              height: 18.r,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              label,
              style: AppTextStyles.buttonMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
            ),
    );
  }
}
