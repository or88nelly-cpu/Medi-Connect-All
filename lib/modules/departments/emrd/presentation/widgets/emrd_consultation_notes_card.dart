import 'package:flutter/material.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/modules/departments/emrd/presentation/widgets/emrd_detail_card.dart';

class EmrdConsultationNotesCard extends StatelessWidget {
  final Map<String, dynamic> record;
  final bool isDark;

  const EmrdConsultationNotesCard({
    super.key,
    required this.record,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return EmrdDetailCard(
      title: "Consultation Notes",
      icon: Icons.sticky_note_2_outlined,
      iconColor: Colors.blueGrey,
      isDark: isDark,
      children: [
        if (record['prescription_notes'] != null &&
            record['prescription_notes'].toString().trim().isNotEmpty)
          Text(
            record['prescription_notes'],
            style: AppTextStyles.bodyMedium.copyWith(
              height: 1.4,
              color: isDark ? Colors.white70 : AppColors.textPrimary(context),
            ),
          )
        else
          Text(
            "No additional notes.",
            style: AppTextStyles.bodySmall.copyWith(
              fontStyle: FontStyle.italic,
              color: isDark ? Colors.white38 : AppColors.textSecondary(context),
            ),
          ),
      ],
    );
  }
}
