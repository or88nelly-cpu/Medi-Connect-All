import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/dash_board/domain/entities/appointment_entity.dart';
import 'complete_consultation_cubit.dart';
import 'consultation_section_header.dart';

class SubmitEmrSection extends StatelessWidget {
  final AppointmentEntity appointment;
  final TextEditingController prescriptionNotesCtrl;
  final VoidCallback onSubmitEMR;

  const SubmitEmrSection({
    super.key,
    required this.appointment,
    required this.prescriptionNotesCtrl,
    required this.onSubmitEMR,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.watch<CompleteConsultationCubit>();
    final state = cubit.state;

    // Build the medicine labels list
    final List<String> medicineNames = [];
    for (final row in state.medicines) {
      final nameCtrl = row['name'] as TextEditingController?;
      final name = nameCtrl?.text.trim() ?? '';
      if (name.isNotEmpty) {
        medicineNames.add(name);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ConsultationSectionHeader(
          icon: Icons.local_hospital_outlined,
          title: 'D. Submit to EMR',
          subtitle: 'Electronic Medical Record',
          color: AppColors.adminPrimary,
        ),
        SizedBox(height: 12.h),

        // Summary details container
        Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: isDark ? AppColors.terminalDarkBg : Colors.grey[50],
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isDark ? AppColors.terminalDarkBorder : AppColors.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEMRRow('Patient', appointment.patientName, isDark),
              _buildEMRRow('Doctor', 'Dr. ${appointment.doctorName}', isDark),
              _buildEMRRow('Specialty', appointment.specialty, isDark),
              _buildEMRRow('Invoice', state.invoiceNumber, isDark),
              if (medicineNames.isNotEmpty)
                _buildEMRRow('Medicines', medicineNames.join(', '), isDark),
              if (state.selectedTests.isNotEmpty)
                _buildEMRRow('Lab Tests', state.selectedTests.join(', '), isDark),
              if (prescriptionNotesCtrl.text.trim().isNotEmpty)
                _buildEMRRow(
                  'Notes',
                  prescriptionNotesCtrl.text.trim(),
                  isDark,
                  isLast: true,
                ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // EMR Submission Button
        if (!state.emrSubmitted)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: state.paymentConfirmed ? onSubmitEMR : null,
              icon: const Icon(Icons.cloud_upload_outlined, color: Colors.white),
              label: Text(
                'Submit to EMR',
                style: AppTextStyles.labelMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.adminPrimary,
                disabledBackgroundColor: AppColors.adminPrimary.withOpacity(0.4),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ),

        if (!state.paymentConfirmed)
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Center(
              child: Text(
                'Complete payment first to enable EMR submission',
                style: AppTextStyles.bodySmall.copyWith(
                  color: isDark ? Colors.white38 : AppColors.textSecondary.withOpacity(0.6),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEMRRow(String label, String value, bool isDark, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 11.sp,
                color: isDark ? Colors.white38 : AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
