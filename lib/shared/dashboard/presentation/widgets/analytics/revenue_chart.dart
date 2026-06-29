import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/analytics/line_chart_painter.dart';

class RevenueChart extends StatelessWidget {
  const RevenueChart({super.key, required this.weeklyRevenue});
  final double? weeklyRevenue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.h,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.weeklyRevenueTrend,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 12.r),
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "₹ $weeklyRevenue",
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),

                  Row(
                    children: [
                      Text(
                        "Today Revenue",
                        style: AppTextStyles.bodySmall.copyWith(
                          //fontWeight: FontWeight.bold,
                          fontSize: 10.sp,
                        ),
                      ),
                      Icon(
                        Icons.arrow_circle_up_outlined,
                        size: 20.r,
                        color: AppColors.success,
                      ),
                    ],
                  ),
                ],
              ),
              CustomPaint(
                size: Size(MediaQuery.of(context).size.width * 0.8, 100.h),
                painter: LineChartPainter(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
