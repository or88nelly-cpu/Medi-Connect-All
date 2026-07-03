import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingStepper extends StatelessWidget {
  final int currentStep;

  const BookingStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStepItem('1', 'Select Doctor', currentStep >= 1),
          _buildStepItem('2', 'Choose Time', currentStep >= 2),
          _buildStepItem('3', 'Confirm & Pay', currentStep >= 3),
          _buildStepItem('4', 'Booked', currentStep >= 4),
        ],
      ),
    );
  }

  Widget _buildStepItem(String step, String label, bool active) {
    return Row(
      children: [
        Container(
          width: 18.r,
          height: 18.r,
          decoration: BoxDecoration(
            color: active ? const Color(0xFF3B5BFD) : Colors.grey.shade400,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            step,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            color: active ? const Color(0xFF3B5BFD) : Colors.grey.shade500,
            fontSize: 9.sp,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
