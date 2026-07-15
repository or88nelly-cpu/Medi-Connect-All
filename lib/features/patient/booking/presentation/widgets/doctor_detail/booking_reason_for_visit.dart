import 'package:flutter/material.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_dimensions.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class BookingReasonForVisit extends StatelessWidget {
  final TextEditingController controller;
  final bool isDark;
  final Color cardBg;
  final Color textColor;

  const BookingReasonForVisit({
    super.key,
    required this.controller,
    required this.isDark,
    required this.cardBg,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reason for Visit',
          style: TextStyle(
            fontSize: AppTextStyles.s14,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0F172A),
          ),
        ),
        SizedBox(height: AppDimensions.spaceS + 2), // 10

        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingS,
          ),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(color: AppColors.border(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: controller,
                maxLines: 3,
                style: TextStyle(color: textColor, fontSize: AppTextStyles.s12 - 1), // 11
                decoration: InputDecoration(
                  hintText:
                      "Tell us the reason for your visit (Optional)\nE.g. Chest pain, regular checkup, shortness of breath...",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: AppTextStyles.s10),
                  border: InputBorder.none,
                ),
              ),
              Text(
                '0/200',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: AppTextStyles.s10 - 2, // 8
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
