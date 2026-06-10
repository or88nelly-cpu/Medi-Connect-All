import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/analytics/custom_line_chart.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/analytics/line_chart_painter.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  final Color color;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // height: 200.4,
        width: 160.w,
        padding: EdgeInsets.all(18.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: color.withAlpha(20), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 30,
              spreadRadius: 2,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: color.withAlpha(20),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50.r,
                  width: 50.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: CustomImageView(imagePath: icon),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 20.sp,

                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        height: 1,
                      ),
                    ),
                    CustomPaint(
                      size: Size(60.r, 20.r),
                      painter: CustomLineChartPainter(
                        lineColor: color,
                        shadowColor: color.withAlpha(125),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.r),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
