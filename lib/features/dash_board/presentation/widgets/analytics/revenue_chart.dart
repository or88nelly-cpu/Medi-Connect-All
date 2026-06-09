import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'line_chart_painter.dart';

class RevenueChart extends StatelessWidget {
  const RevenueChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.h,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.weeklyRevenueTrend,
            style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: CustomPaint(
              size: Size.infinite,
              painter: LineChartPainter(),
            ),
          ),
        ],
      ),
    );
  }
}
