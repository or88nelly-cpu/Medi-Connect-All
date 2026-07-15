import 'package:flutter/material.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_dimensions.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class BookingSummarySection extends StatelessWidget {
  final dynamic user;
  final String specialityName;
  final String selectedDate;
  final String? selectedSlot;
  final double fee;
  final bool isDark;
  final Color cardBg;
  final Color textColor;

  const BookingSummarySection({
    super.key,
    required this.user,
    required this.specialityName,
    required this.selectedDate,
    required this.selectedSlot,
    required this.fee,
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
          'Booking Summary',
          style: TextStyle(
            fontSize: AppTextStyles.s14,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0F172A),
          ),
        ),
        SizedBox(height: AppDimensions.spaceS + 2), // 10
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Details Table
            Expanded(
              flex: 6,
              child: Column(
                children: [
                  _buildSummaryItem(
                    'Doctor',
                    '${user.fullName} ($specialityName)',
                    textColor,
                  ),
                  _buildSummaryItem('Date', selectedDate, textColor),
                  _buildSummaryItem(
                    'Time',
                    selectedSlot ?? 'Not Selected',
                    textColor,
                  ),
                  _buildSummaryItem(
                    'Consultation Fee',
                    '₹${fee.toStringAsFixed(0)}',
                    textColor,
                  ),
                  const Divider(color: Colors.grey, height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: AppTextStyles.s12,
                          fontWeight: FontWeight.w900,
                          color: textColor,
                        ),
                      ),
                      Text(
                        '₹${fee.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: AppTextStyles.s14,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF3B5BFD),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: AppDimensions.spaceWXL - 6), // 14

            // Safe & Secure Booking Banner
            Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.all(AppDimensions.paddingS + 2), // 10
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F6FF),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.verified_user_outlined,
                          color: Color(0xFF3B5BFD),
                          size: 14,
                        ),
                        SizedBox(width: AppDimensions.spaceWXS),
                        const Text(
                          'Safe & Secure Booking',
                          style: TextStyle(
                            color: Color(0xFF3B5BFD),
                            fontSize: 7.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.spaceXS + 2), // 6
                    Text(
                      'Your appointment is confirmed only after successful payment.',
                      style: TextStyle(
                        fontSize: 7,
                        color: Colors.grey.shade700,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: AppDimensions.spaceS),
                    _buildSecureBullet('HIPAA Compliant'),
                    _buildSecureBullet('Secure Payments'),
                    _buildSecureBullet('Your data is safe'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String val, Color textColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingXS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            val,
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecureBullet(String label) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_outline_rounded,
          color: Color(0xFF10B981),
          size: 8,
        ),
        SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 7,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
