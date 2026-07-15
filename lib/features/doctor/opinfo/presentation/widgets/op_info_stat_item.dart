import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class OpInfoStatItem extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;
  final Color color;

  const OpInfoStatItem({
    super.key,
    required this.icon,
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 16.r),
        SizedBox(height: 4.h),
        Text(
          count.toString(),
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: isDark ? Colors.white54 : Colors.grey,
            fontSize: 8.sp,
          ),
          maxLines: 2,
        ),
      ],
    );
  }
}
