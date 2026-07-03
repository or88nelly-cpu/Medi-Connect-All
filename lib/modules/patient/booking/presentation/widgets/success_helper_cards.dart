import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

class SuccessHelperCards extends StatelessWidget {
  final VoidCallback onCalendarTap;
  final VoidCallback onSupportTap;
  final Color cardBg;
  final Color textColor;

  const SuccessHelperCards({
    super.key,
    required this.onCalendarTap,
    required this.onSupportTap,
    required this.cardBg,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildHelpWidget(
            Icons.calendar_month_outlined,
            'Add to Calendar',
            'Never miss your appointment.',
            'Add to Calendar',
            onCalendarTap,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _buildHelpWidget(
            Icons.headset_mic_outlined,
            'Need Help?',
            'Our care team is here to assist you.',
            'Contact Support',
            onSupportTap,
          ),
        ),
      ],
    );
  }

  Widget _buildHelpWidget(
    IconData icon,
    String title,
    String sub,
    String buttonText,
    VoidCallback onTap,
  ) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 16.r),
              SizedBox(width: 6.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            sub,
            style: TextStyle(
              fontSize: 7.5.sp,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8.r),
              ),
              alignment: Alignment.center,
              child: Text(
                buttonText,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
