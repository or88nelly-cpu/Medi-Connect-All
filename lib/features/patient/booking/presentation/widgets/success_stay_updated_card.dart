import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/features/authentication/presentation/bloc/auth_bloc.dart';

class SuccessStayUpdatedCard extends StatelessWidget {
  final Color cardBg;
  final Color textColor;

  const SuccessStayUpdatedCard({
    super.key,
    required this.cardBg,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    String patientEmail = 'likhin@gmail.com';
    String patientPhone = '+91 98765 43210';
    if (authState is Authenticated) {
      patientEmail = authState.user.email ?? 'likhin@gmail.com';
      patientPhone = authState.user.phone ?? '+91 98765 43210';
    }

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: const BoxDecoration(
              color: Color(0xFFF3E8FF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_active_rounded,
              color: const Color(0xFF8B5CF6),
              size: 24.r,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stay Updated',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
                Text(
                  'We will send you a reminder before your appointment.',
                  style: TextStyle(
                    fontSize: 8.5.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 4.h,
                  children: [
                    _buildUpdatedBadge('Email', patientEmail),
                    _buildUpdatedBadge('SMS', patientPhone),
                    _buildUpdatedBadge('Push Notification', 'Enabled'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdatedBadge(String tag, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$tag: $value',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 7.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 3.w),
          Icon(
            Icons.check_circle_rounded,
            color: const Color(0xFF10B981),
            size: 8.r,
          ),
        ],
      ),
    );
  }
}
