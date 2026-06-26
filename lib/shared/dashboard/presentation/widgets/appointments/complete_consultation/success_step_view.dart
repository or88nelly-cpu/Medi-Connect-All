import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/buttons/gradient_button.dart';
import 'package:medi_connect/shared/dashboard/domain/entities/appointment_entity.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/appointments/complete_consultation/complete_consultation_cubit.dart';

class SuccessStepView extends StatelessWidget {
  final AppointmentEntity appointment;
  final VoidCallback onViewInvoice;
  final VoidCallback onBackToAppointments;

  const SuccessStepView({
    super.key,
    required this.appointment,
    required this.onViewInvoice,
    required this.onBackToAppointments,
  });

  String _cleanDoctorName(String name) {
    String cleaned = name
        .replaceAll(RegExp(r'^(Dr\.\s*)+', caseSensitive: false), '')
        .trim();
    return 'Dr. $cleaned';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.watch<CompleteConsultationCubit>();
    final state = cubit.state;

    final docName = _cleanDoctorName(appointment.doctorName);
    final formattedDate = DateFormat(
      'dd MMM yyyy, hh:mm a',
    ).format(DateTime.now());

    final cardBg = isDark ? AppColors.terminalDarkCard : Colors.white;
    final borderColor = AppColors.border(context);

    return Column(
      children: [
        SizedBox(height: 24.h),
        // Success Circle Icon with confetti dots around
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer circle
              Container(
                width: 90.r,
                height: 90.r,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
              ),
              // Middle circle
              Container(
                width: 72.r,
                height: 72.r,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
              ),
              // Inner circle and Check
              Container(
                width: 56.r,
                height: 56.r,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 36),
              ),
              // Confetti mockup dots
              Positioned(
                top: 4.h,
                left: 10.w,
                child: _buildDot(6, Colors.blue, 0.8),
              ),
              Positioned(
                bottom: 8.h,
                right: 4.w,
                child: _buildDot(8, Colors.yellow[600]!, 0.9),
              ),
              Positioned(
                top: 18.h,
                right: 8.w,
                child: _buildDot(5, Colors.purple, 0.7),
              ),
              Positioned(
                bottom: 4.h,
                left: 18.w,
                child: _buildDot(7, Colors.green, 0.8),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // Title and Subtitle
        Text(
          'Consultation Completed!',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
            color: isDark ? Colors.white : AppColors.textPrimary(context),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'The consultation has been completed successfully.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? Colors.white54 : AppColors.textSecondary(context),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24.h),

        // Summary Detail Box Card
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              _buildSummaryRow(
                Icons.person_outline,
                'Patient',
                appointment.patientName,
                isDark,
                context,
              ),
              _buildSummaryRow(
                Icons.local_hospital_outlined,
                'Doctor',
                '$docName (${appointment.specialty})',
                isDark,
                context,
              ),
              _buildSummaryRow(
                Icons.calendar_today_outlined,
                'Date & Time',
                formattedDate,
                isDark,
                context,
              ),
              _buildSummaryRow(
                Icons.receipt_long_outlined,
                'Invoice Number',
                state.invoiceNumber,
                isDark,
                context,
              ),
              _buildSummaryRow(
                Icons.payments_outlined,
                'Amount Paid',
                '₹${state.totalFee.toStringAsFixed(2)}',
                isDark,
                context,
                isLast: true,
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),

        // EMR Submitted success banner
        Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.success.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_user_outlined,
                  color: AppColors.success,
                  size: 18,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EMR submitted successfully',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'You can view the record in EMR Department.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDark
                            ? Colors.white54
                            : AppColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30.h),

        // Bottom Action buttons matching exact design
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onViewInvoice,
                icon: const Icon(Icons.receipt_long, size: 16),
                label: const Text(
                  'View Invoice',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue[700],
                  side: BorderSide(color: Colors.blue[600]!, width: 1.2),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: GradientButton(
                text: 'Back to Appointments',
                onPressed: onBackToAppointments,
                height: 48.h,
                borderRadius: 10.r,
                gradientColors: const [AppColors.primary, Colors.blueAccent],
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDot(double size, Color color, double opacity) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: size.r,
        height: size.r,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }

  Widget _buildSummaryRow(
    IconData icon,
    String label,
    String value,
    bool isDark,
    BuildContext context, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12.h),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16.r,
            color: AppColors.textSecondary(context).withValues(alpha: 0.7),
          ),
          SizedBox(width: 10.w),
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isDark
                    ? Colors.white54
                    : AppColors.textSecondary(context),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimary(context),
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
