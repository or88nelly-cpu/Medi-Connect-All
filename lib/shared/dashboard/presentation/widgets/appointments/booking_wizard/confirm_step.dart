import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/appointments/booking_wizard/booking_wizard_cubit.dart';

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
            color: isDark ? Colors.white54 : AppColors.textSecondary(context),
          ),
        ),
      );
    }

    final formattedDate = DateFormat(
      'EEEE, dd MMM yyyy',
    ).format(state.selectedDate);
    final patientName =
        state.selectedPatient!.fullName ??
        '${state.selectedPatient!.firstName} ${state.selectedPatient!.lastName}'
            .trim();
    final doctorName =
        state.selectedDoctor!.fullName ??
        '${state.selectedDoctor!.firstName} ${state.selectedDoctor!.lastName}'
            .trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Consultation Type",
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimary(context),
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
                      : (AppColors.border(context)),
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
                      : (AppColors.border(context)),
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
            color: isDark ? Colors.white : AppColors.textPrimary(context),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: isDark ? AppColors.terminalDarkBg : Colors.grey[50],
            border: Border.all(color: AppColors.border(context)),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            children: [
              _buildReviewRow("Patient", patientName, isDark, context),
              _buildReviewRow(
                "Specialty",
                state.selectedSection!.name,
                isDark,
                context,
              ),
              _buildReviewRow("Doctor", doctorName, isDark, context),
              _buildReviewRow("Date", formattedDate, isDark, context),
              _buildReviewRow(
                "Time Slot",
                state.selectedSlotTime!,
                isDark,
                context,
              ),
              _buildReviewRow("Type", state.selectedType, isDark, context),
              _buildReviewRow(
                "Consultation Fee",
                state.isLoadingFeeCheck
                    ? "Calculating..."
                    : state.isFollowUp
                    ? "₹0.00 (Follow-up)"
                    : "₹${state.consultationFee.toStringAsFixed(2)}",
                isDark,
                isLast: true,
                context,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewRow(
    String label,
    String value,
    bool isDark,
    BuildContext context, {
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
              color: isDark ? Colors.white54 : AppColors.textSecondary(context),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary(context),
            ),
          ),
        ],
      ),
    );
  }
}
