import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/domain/entities/patient_entity.dart';
import 'package:medi_connect/shared/auth/domain/entities/user_entity.dart';

class PatientPersonalInfoCard extends StatelessWidget {
  final UserEntity user;
  final PatientEntity patient;

  const PatientPersonalInfoCard({
    super.key,
    required this.user,
    required this.patient,
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
              "Personal Details",
              style: AppTextStyles.titleMedium.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            _buildDetailRow("UHID / Patient No", patient.patientNo ?? 'Not Assigned', context),
            _buildDetailRow("Registration Source", patient.registrationSource ?? 'Online', context),
            _buildDetailRow("Referred By", patient.referredBy ?? 'Self', context),
            _buildDetailRow("Marital Status", patient.maritalStatus ?? 'Single', context),
            _buildDetailRow("Occupation", patient.occupation ?? 'N/A', context),
            _buildDetailRow("Nationality", patient.nationality ?? 'N/A', context),
            _buildDetailRow("Address", patient.address ?? 'Not Set', context),
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
              textAlign: Alignment.centerRight.x > 0 ? TextAlign.end : TextAlign.start,
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
