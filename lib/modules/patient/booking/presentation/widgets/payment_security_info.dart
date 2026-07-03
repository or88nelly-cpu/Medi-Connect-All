import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentSecurityInfo extends StatelessWidget {
  const PaymentSecurityInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F6FF),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Safe & Secure Payments',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1E3A8A),
            ),
          ),
          SizedBox(height: 14.h),
          _buildSecurityBullet('HIPAA Compliant'),
          SizedBox(height: 8.h),
          _buildSecurityBullet('256-bit SSL Encryption'),
          SizedBox(height: 8.h),
          _buildSecurityBullet('Secure Transactions'),
          SizedBox(height: 8.h),
          _buildSecurityBullet('Your data is always protected'),
          SizedBox(height: 24.h),
          Center(
            child: Icon(
              Icons.shield_rounded,
              color: const Color(0xFF3B5BFD).withValues(alpha: 0.15),
              size: 100.r,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityBullet(String label) {
    return Row(
      children: [
        Icon(
          Icons.check_circle_outline_rounded,
          color: const Color(0xFF10B981),
          size: 12.r,
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 8.5.sp,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
