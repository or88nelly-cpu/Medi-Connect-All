import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/features/patient/booking/presentation/bloc/speciality_booking_bloc.dart';
import 'package:medi_connect/features/patient/booking/presentation/bloc/speciality_booking_state.dart';
import 'package:intl/intl.dart';

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Booking Summary
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class BookingSummarySection extends StatelessWidget {
  final dynamic user;
  final String specialityName;
  final double fee;
  final Color cardBg;
  final Color textColor;

  const BookingSummarySection({
    super.key,
    required this.user,
    required this.specialityName,
    required this.fee,
    required this.cardBg,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpecialityBookingBloc, SpecialityBookingState>(
      builder: (context, state) {
        String selectedDateStr = 'Not Selected';
        if (state.selectedDate != null) {
          selectedDateStr = DateFormat('E, MMM d').format(state.selectedDate!);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Summary',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: Column(
                    children: [
                      _buildSummaryItem(
                        'Doctor',
                        '${user.fullName} ($specialityName)',
                        textColor,
                      ),
                      _buildSummaryItem('Date', selectedDateStr, textColor),
                      _buildSummaryItem(
                        'Time',
                        state.selectedSlot ?? 'Not Selected',
                        textColor,
                      ),
                      _buildSummaryItem(
                        'Consultation Fee',
                        'â‚¹${fee.toStringAsFixed(0)}',
                        textColor,
                      ),
                      const Divider(color: Colors.grey, height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w900,
                              color: textColor,
                            ),
                          ),
                          Text(
                            'â‚¹${fee.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF3B5BFD),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F6FF),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.verified_user_outlined,
                              color: const Color(0xFF3B5BFD),
                              size: 14.r,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Safe & Secure Booking',
                              style: TextStyle(
                                color: const Color(0xFF3B5BFD),
                                fontSize: 7.5.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'Your appointment is confirmed only after successful payment.',
                          style: TextStyle(
                            fontSize: 7.sp,
                            color: Colors.grey.shade700,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 8.h),
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
      },
    );
  }

  Widget _buildSummaryItem(String label, String val, Color textColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            val,
            style: TextStyle(
              color: textColor,
              fontSize: 10.sp,
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
        Icon(
          Icons.check_circle_outline_rounded,
          color: const Color(0xFF10B981),
          size: 8.r,
        ),
        SizedBox(width: 3.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 7.sp,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Payment Method Section
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class BookingPaymentMethodSection extends StatelessWidget {
  final Color cardBg;

  const BookingPaymentMethodSection({super.key, required this.cardBg});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0F172A),
          ),
        ),
        SizedBox(height: 10.h),
        BlocBuilder<SpecialityBookingBloc, SpecialityBookingState>(
          builder: (context, state) {
            return Row(
              children: [
                _buildPaymentItem(
                  context,
                  0,
                  Icons.qr_code_scanner_rounded,
                  'UPI',
                  'GPay, PhonePe',
                  state.paymentMethodIndex,
                  cardBg,
                ),
                SizedBox(width: 8.w),
                _buildPaymentItem(
                  context,
                  1,
                  Icons.credit_card_rounded,
                  'Card',
                  'Visa, MasterCard',
                  state.paymentMethodIndex,
                  cardBg,
                ),
                SizedBox(width: 8.w),
                _buildPaymentItem(
                  context,
                  2,
                  Icons.account_balance_rounded,
                  'Net Banking',
                  'All Major Banks',
                  state.paymentMethodIndex,
                  cardBg,
                ),
                SizedBox(width: 8.w),
                _buildPaymentItem(
                  context,
                  3,
                  Icons.account_balance_wallet_rounded,
                  'Wallet',
                  'Paytm, Mobikwik',
                  state.paymentMethodIndex,
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
        onTap: () => context.read<SpecialityBookingBloc>().add(
          UpdatePaymentMethod(index: index),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14.r),
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
                size: 18.r,
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF3B5BFD) : Colors.black87,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                sub,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 6.5.sp,
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
