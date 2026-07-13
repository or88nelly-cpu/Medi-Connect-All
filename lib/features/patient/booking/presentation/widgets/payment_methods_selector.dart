import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

class PaymentMethodsSelector extends StatelessWidget {
  final ValueNotifier<int> selectedPaymentNotifier;
  final Color cardBg;

  const PaymentMethodsSelector({
    super.key,
    required this.selectedPaymentNotifier,
    required this.cardBg,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedPaymentNotifier,
      builder: (context, selectedIdx, _) {
        return Column(
          children: [
            _buildPaymentOption(
              context,
              0,
              Icons.qr_code_scanner_rounded,
              'UPI',
              'Pay using any UPI app',
              selectedIdx,
            ),
            SizedBox(height: 10.h),
            _buildPaymentOption(
              context,
              1,
              Icons.credit_card_rounded,
              'Credit / Debit Card',
              'Visa, MasterCard, Rupay & more',
              selectedIdx,
            ),
            SizedBox(height: 10.h),
            _buildPaymentOption(
              context,
              2,
              Icons.account_balance_rounded,
              'Net Banking',
              'Pay using your bank account',
              selectedIdx,
            ),
            SizedBox(height: 10.h),
            _buildPaymentOption(
              context,
              3,
              Icons.account_balance_wallet_rounded,
              'Wallet',
              'Paytm, Mobikwik & more',
              selectedIdx,
            ),
            SizedBox(height: 10.h),
            _buildPaymentOption(
              context,
              4,
              Icons.pending_actions_rounded,
              'Pay Later',
              'Pay at counter or reception desk',
              selectedIdx,
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaymentOption(
    BuildContext context,
    int index,
    IconData icon,
    String title,
    String desc,
    int selectedIdx,
  ) {
    final isSelected = selectedIdx == index;
    return GestureDetector(
      onTap: () => selectedPaymentNotifier.value = index,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF3B5BFD)
                : AppColors.border(context),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF3B5BFD) : Colors.grey,
              size: 22.r,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w900,
                      color: isSelected
                          ? const Color(0xFF3B5BFD)
                          : Colors.black87,
                    ),
                  ),
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 16.r,
              height: 16.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF3B5BFD)
                      : Colors.grey.shade400,
                  width: isSelected ? 4 : 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
