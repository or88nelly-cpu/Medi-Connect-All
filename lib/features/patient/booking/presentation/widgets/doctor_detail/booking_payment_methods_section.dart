import 'package:flutter/material.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_dimensions.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class BookingPaymentMethodsSection extends StatelessWidget {
  final ValueNotifier<int> selectedPaymentNotifier;
  final bool isDark;
  final Color cardBg;
  final Color textColor;

  const BookingPaymentMethodsSection({
    super.key,
    required this.selectedPaymentNotifier,
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
          'Payment Method',
          style: TextStyle(
            fontSize: AppTextStyles.s14,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0F172A),
          ),
        ),
        SizedBox(height: AppDimensions.spaceS + 2), // 10
        // Row of options
        ValueListenableBuilder<int>(
          valueListenable: selectedPaymentNotifier,
          builder: (context, selectedIdx, _) {
            return Row(
              children: [
                _buildPaymentItem(
                  context,
                  0,
                  Icons.qr_code_scanner_rounded,
                  'UPI',
                  'GPay, PhonePe',
                  selectedIdx,
                  cardBg,
                ),
                SizedBox(width: AppDimensions.spaceWS),
                _buildPaymentItem(
                  context,
                  1,
                  Icons.credit_card_rounded,
                  'Card',
                  'Visa, MasterCard',
                  selectedIdx,
                  cardBg,
                ),
                SizedBox(width: AppDimensions.spaceWS),
                _buildPaymentItem(
                  context,
                  2,
                  Icons.account_balance_rounded,
                  'Net Banking',
                  'All Major Banks',
                  selectedIdx,
                  cardBg,
                ),
                SizedBox(width: AppDimensions.spaceWS),
                _buildPaymentItem(
                  context,
                  3,
                  Icons.account_balance_wallet_rounded,
                  'Wallet',
                  'Paytm, Mobikwik',
                  selectedIdx,
                  cardBg,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildPaymentItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
    String sub,
    int selectedIdx,
    Color cardBg,
  ) {
    final isSelected = selectedIdx == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => selectedPaymentNotifier.value = index,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: AppDimensions.paddingS + 2, // 10
            horizontal: AppDimensions.paddingXS, // 4
          ),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(
              AppDimensions.radiusL - 2,
            ), // 14
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF3B5BFD)
                  : AppColors.border(context),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFF3B5BFD) : Colors.grey,
                size: 18,
              ),
              SizedBox(height: AppDimensions.spaceXS),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF3B5BFD) : Colors.black87,
                  fontSize: AppTextStyles.s10 - 1, // 9
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                sub,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 6.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
