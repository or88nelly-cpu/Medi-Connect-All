import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class PatientGreeting extends StatelessWidget {
  final String name;

  const PatientGreeting({super.key, required this.name});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _greeting(),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary(context),
            fontSize: 13.sp,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                name,
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColors.dashboardTextPrimary(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 4.w),
            Text('👋', style: TextStyle(fontSize: 18.sp)),
          ],
        ),
      ],
    );
  }
}
