import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/modules/patient/booking/presentation/widgets/booking_stepper.dart';

class SuccessHeader extends StatelessWidget {
  final bool isPayLater;
  final bool isDark;

  const SuccessHeader({
    super.key,
    required this.isPayLater,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Stepper progress tracker
        const BookingStepper(currentStep: 4),
        SizedBox(height: 24.h),

        // Success Icon Circle
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 90.r,
              height: 90.r,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFC8E6C9), width: 3),
              ),
            ),
            Icon(
              Icons.check_circle_rounded,
              color: const Color(0xFF22C55E),
              size: 64.r,
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Header Messages
        Text(
          isPayLater ? 'Booking Successful!' : 'Payment Successful!',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF1E3A8A),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          isPayLater ? 'Your appointment is scheduled' : 'Your appointment is confirmed',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF22C55E),
          ),
        ),
        SizedBox(height: 6.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            'We have sent the appointment details to your registered email and mobile number.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
        ),
        SizedBox(height: 16.h),

        // 100% Secure Transaction details
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2FE),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified_user_rounded, color: const Color(0xFF3B5BFD), size: 14.r),
              SizedBox(width: 6.w),
              Text(
                isPayLater
                    ? 'Secure Booking • Booking confirmed and secure.'
                    : '100% Secure Payment • Your transaction was successful and secure.',
                style: TextStyle(
                  color: const Color(0xFF3B5BFD),
                  fontSize: 8.sp,
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
