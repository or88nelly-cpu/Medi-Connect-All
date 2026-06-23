import 'package:flutter/material.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/modules/departments/emrd/presentation/widgets/emrd_detail_card.dart';

class EmrdGeneralInfoCard extends StatelessWidget {
  final Map<String, dynamic> record;
  final bool isDark;

  const EmrdGeneralInfoCard({
    super.key,
    required this.record,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return EmrdDetailCard(
      title: "General Information",
      icon: Icons.person_outline,
      iconColor: AppColors.primary,
      isDark: isDark,
      children: [
        EmrdInfoRow(
          label: "Patient Name",
          value: record['patient_name'] ?? 'N/A',
          isDark: isDark,
        ),
        EmrdInfoRow(
          label: "Doctor Name",
          value: 'Dr. ${record['doctor_name'] ?? "N/A"}',
          isDark: isDark,
        ),
        EmrdInfoRow(
          label: "Specialty",
          value: record['specialty'] ?? 'N/A',
          isDark: isDark,
        ),
        EmrdInfoRow(
          label: "Invoice Number",
          value: record['invoice_number'] ?? 'N/A',
          isDark: isDark,
        ),
      ],
    );
  }
}
