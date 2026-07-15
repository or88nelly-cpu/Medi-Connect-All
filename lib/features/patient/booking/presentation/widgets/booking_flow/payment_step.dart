import 'package:flutter/material.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_dimensions.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/features/authentication/data/models/user_model.dart';
import 'package:medi_connect/features/patient/booking/presentation/pages/booking_flow_page.dart';

class PaymentStep extends StatelessWidget {
  final UserModel? doctor;
  final SpecialtyEntry? specialty;
  final DateTime date;
  final String slot;
  final String paymentMethod;
  final bool isProcessing;
  final ValueChanged<String> onMethodChanged;

  const PaymentStep({
    super.key,
    required this.doctor,
    required this.specialty,
    required this.date,
    required this.slot,
    required this.paymentMethod,
    required this.isProcessing,
    required this.onMethodChanged,
  });

  String _monthName(int m) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[(m - 1).clamp(0, 11)];
  }

  @override
  Widget build(BuildContext context) {
    const fee = 500;
    final tax = (fee * 0.18).round();
    final total = fee + tax;
    final color = specialty?.gradient.first ?? AppColors.primary;

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment',
            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: AppDimensions.spaceL),

          // Booking summary card
          Container(
            padding: EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Booking Summary',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.textPrimary(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(color: color.withValues(alpha: 0.2), height: AppDimensions.spaceL),
                SummaryRow(
                  label: 'Doctor',
                  value: doctor?.fullName ?? 'Dr. Specialist',
                  color: color,
                ),
                SizedBox(height: AppDimensions.spaceS),
                SummaryRow(
                  label: 'Specialty',
                  value: specialty?.name ?? 'General Medicine',
                  color: color,
                ),
                SizedBox(height: AppDimensions.spaceS),
                SummaryRow(
                  label: 'Date & Time',
                  value:
                      '${_monthName(date.month)} ${date.day}, ${date.year} · $slot',
                  color: color,
                ),
                Divider(color: color.withValues(alpha: 0.2), height: AppDimensions.spaceXL),
                SummaryRow(
                  label: 'Consultation Fee',
                  value: '₹$fee',
                  color: color,
                ),
                SizedBox(height: AppDimensions.spaceXS + 2),
                SummaryRow(label: 'GST (18%)', value: '₹$tax', color: color),
                Divider(color: color.withValues(alpha: 0.2), height: AppDimensions.spaceL),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Payable',
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    Text(
                      '₹$total',
                      style: TextStyle(
                        fontSize: AppTextStyles.s18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: AppDimensions.spaceXL),

          Text(
            'Payment Method',
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.textPrimary(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppDimensions.spaceM),

          ...kPaymentMethods.map((m) {
            final id = m['id'] as String;
            final label = m['label'] as String;
            final icon = m['icon'] as IconData;
            final mColor = Color(m['color'] as int);
            final isSelected = paymentMethod == id;

            return GestureDetector(
              onTap: () => onMethodChanged(id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.only(bottom: AppDimensions.spaceS),
                padding: EdgeInsets.all(AppDimensions.paddingL - 2), // 14
                decoration: BoxDecoration(
                  color: isSelected
                      ? mColor.withValues(alpha: 0.07)
                      : AppColors.card(context),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL - 2), // 14
                  border: Border.all(
                    color: isSelected ? mColor : AppColors.border(context),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: mColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusM - 2), // 10
                      ),
                      child: Icon(icon, color: mColor, size: 20),
                    ),
                    SizedBox(width: AppDimensions.spaceWM),
                    Expanded(
                      child: Text(
                        label,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary(context),
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? mColor : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? mColor
                              : AppColors.border(context),
                        ),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 12,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary(context),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
