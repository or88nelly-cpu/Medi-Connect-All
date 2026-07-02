import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/domain/entities/employee_entity.dart';

class EmployeeWorkCard extends StatelessWidget {
  final EmployeeEntity employee;

  const EmployeeWorkCard({
    super.key,
    required this.employee,
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
              "Employment & Status",
              style: AppTextStyles.titleMedium.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            _buildDetailRow("Department ID", employee.departmentId ?? 'Default', context),
            _buildDetailRow("Designation ID", employee.designationId ?? 'Staff', context),
            _buildDetailRow("Employment Type ID", employee.employmentTypeId ?? 'Full-time', context),
            _buildDetailRow("Reporting Manager ID", employee.reportingManager ?? 'None', context),
            _buildDetailRow("Last Login Time", employee.lastLoginAt != null ? employee.lastLoginAt!.toLocal().toString() : 'Never', context),
            _buildDetailRow("Last Active Time", employee.activeAt != null ? employee.activeAt!.toLocal().toString() : 'Never', context),
            _buildDetailRow("Last Login IP", employee.lastLoginIp ?? 'N/A', context),
            _buildDetailRow("Last Login Device", employee.lastLoginDevice ?? 'N/A', context),
            _buildDetailRow("Current Location", employee.currentLocation ?? 'Not Tracked', context),
            _buildDetailRow("GPS Coordinates", employee.currentLatitude != null && employee.currentLongitude != null
                ? "${employee.currentLatitude}, ${employee.currentLongitude}"
                : 'N/A', context),
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
