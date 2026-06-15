import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'booking_wizard_cubit.dart';

class ConfirmStep extends StatelessWidget {
  const ConfirmStep({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.watch<BookingWizardCubit>();
    final state = cubit.state;

    if (state.selectedPatient == null ||
        state.selectedSection == null ||
        state.selectedDoctor == null ||
        state.selectedSlotTime == null) {
      return Center(
        child: Text(
          "Incomplete wizard configuration",
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? Colors.white54 : AppColors.textSecondary,
          ),
        ),
      );
    }

    final formattedDate = DateFormat(
      'EEEE, dd MMM yyyy',
    ).format(state.selectedDate);
    final patientName =
        state.selectedPatient!.name ??
        '${state.selectedPatient!.firstName} ${state.selectedPatient!.lastName}'
            .trim();
    final doctorName =
        state.selectedDoctor!.name ??
        '${state.selectedDoctor!.firstName} ${state.selectedDoctor!.lastName}'
            .trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Consultation Type",
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            Expanded(
              child: ChoiceChip(
                label: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: const Text("Regular Consultation"),
                ),
                selected: state.selectedType == 'Consultation',
                onSelected: (val) {
                  if (val) cubit.selectType('Consultation');
                },
                selectedColor: AppColors.primary.withValues(alpha: 0.2),
                checkmarkColor: AppColors.primary,
                side: BorderSide(
                  color: state.selectedType == 'Consultation'
                      ? AppColors.primary
                      : (isDark
                            ? AppColors.terminalDarkBorder
                            : AppColors.border),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: ChoiceChip(
                label: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: const Text("Video Consultation"),
                ),
                selected: state.selectedType == 'Video',
                onSelected: (val) {
                  if (val) cubit.selectType('Video');
                },
                selectedColor: AppColors.primary.withValues(alpha: 0.2),
                checkmarkColor: AppColors.primary,
                side: BorderSide(
                  color: state.selectedType == 'Video'
                      ? AppColors.primary
                      : (isDark
                            ? AppColors.terminalDarkBorder
                            : AppColors.border),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        Text(
          "Appointment Review Summary",
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: isDark ? AppColors.terminalDarkBg : Colors.grey[50],
            border: Border.all(
              color: isDark ? AppColors.terminalDarkBorder : AppColors.border,
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            children: [
              _buildReviewRow("Patient", patientName, isDark),
              _buildReviewRow("Specialty", state.selectedSection!.name, isDark),
              _buildReviewRow("Doctor", doctorName, isDark),
              _buildReviewRow("Date", formattedDate, isDark),
              _buildReviewRow("Time Slot", state.selectedSlotTime!, isDark),
              _buildReviewRow("Type", state.selectedType, isDark, isLast: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewRow(
    String label,
    String value,
    bool isDark, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 11.sp,
              color: isDark ? Colors.white54 : AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
