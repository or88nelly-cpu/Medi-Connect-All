import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/domain/entities/doctor_entity.dart';

class DoctorFeeScheduleCard extends StatelessWidget {
  final DoctorEntity doctor;

  const DoctorFeeScheduleCard({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;

    return Card(
      color: cardBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: AppColors.border(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Consultation Fees & Availability",
              style: AppTextStyles.titleMedium.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            _buildDetailRow("Initial Consultation Fee", "\$${doctor.consultationFee.toStringAsFixed(2)}", context),
            _buildDetailRow("Follow-up Consultation Fee", "\$${doctor.followupFee.toStringAsFixed(2)}", context),
            _buildDetailRow("Consultation Duration", "${doctor.consultationDuration} Mins", context),
            _buildDetailRow("Accepts Online Consultations", doctor.acceptsOnlineConsultation ? 'Yes' : 'No', context),
            _buildDetailRow("Is Currently Available", doctor.isAvailable ? 'Yes' : 'No', context),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary(context),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
