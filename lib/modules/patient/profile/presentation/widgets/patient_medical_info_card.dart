import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/domain/entities/patient_entity.dart';

class PatientMedicalInfoCard extends StatelessWidget {
  final PatientEntity patient;

  const PatientMedicalInfoCard({
    super.key,
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
              "Medical Information",
              style: AppTextStyles.titleMedium.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            _buildDetailRow("Blood Group", patient.bloodGroup ?? 'Not Specified', context),
            _buildDetailRow("Height (cm)", patient.height != null ? "${patient.height} cm" : 'Not Set', context),
            _buildDetailRow("Weight (kg)", patient.weight != null ? "${patient.weight} kg" : 'Not Set', context),
            _buildDetailRow("Allergies", patient.allergies ?? 'No Known Allergies', context),
            _buildDetailRow("Chronic Diseases", patient.chronicDiseases ?? 'No Chronic Diseases', context),
            _buildDetailRow("Remarks/Notes", patient.remarks ?? 'None', context),
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
