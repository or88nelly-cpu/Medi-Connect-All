import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/widgets/buttons/common_button.dart';

class PaymentCheckoutBar extends StatelessWidget {
  final double fee;
  final ValueNotifier<int> selectedPaymentNotifier;
  final bool isLoading;
  final VoidCallback onCheckoutPressed;
  final Color cardBg;

  const PaymentCheckoutBar({
    super.key,
    required this.fee,
    required this.selectedPaymentNotifier,
    required this.isLoading,
    required this.onCheckoutPressed,
    required this.cardBg,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedPaymentNotifier,
      builder: (context, paymentIdx, _) {
        final isPayLater = paymentIdx == 4;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: cardBg,
            border: Border(top: BorderSide(color: AppColors.border(context))),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '₹${fee.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1E3A8A),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.verified_user_rounded,
                        color: const Color(0xFF10B981),
                        size: 14.r,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Secure Payment\nSSL Encrypted',
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  CommonButton(
                    text: isPayLater
                        ? 'Confirm Booking'
                        : 'Pay ₹${fee.toStringAsFixed(0)}',
                    isLoading: isLoading,
                    width: 170.w,
                    height: 48.h,
                    borderRadius: 16.r,
                    color: const Color(0xFF3B5BFD),
                    onPressed: onCheckoutPressed,
                    icon: Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                      size: 16.r,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shield_outlined, color: Colors.grey, size: 10.r),
                  SizedBox(width: 4.w),
                  Text(
                    'By proceeding, you agree to our Terms & Conditions',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
