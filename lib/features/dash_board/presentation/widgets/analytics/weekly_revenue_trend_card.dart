import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class WeeklyRevenueTrendCard extends StatelessWidget {
  final double weeklyRevenue;

  const WeeklyRevenueTrendCard({
    super.key,
    required this.weeklyRevenue,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.weeklyRevenueTrend.toUpperCase(),
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: labelColor,
                  fontSize: 10.sp,
                  letterSpacing: 0.8,
                ),
              ),
              Icon(
                Icons.info_outline,
                color: labelColor,
                size: 16.r,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            "₹ $weeklyRevenue",
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor,
              fontSize: 22.sp,
            ),
          ),
          Text(
            AppStrings.totalThisWeek,
            style: AppTextStyles.bodySmall.copyWith(
              color: labelColor,
              fontSize: 10.sp,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 100.h,
            width: double.infinity,
            child: CustomPaint(
              painter: _RevenueChartPainter(
                lineColor: AppColors.primary,
                fillColor: AppColors.primary.withValues(alpha: 0.15),
                labelColor: labelColor,
              ),
            ),
          ),
          SizedBox(height: 16.h), // Extra padding below the day labels
        ],
      ),
    );
  }
}

class _RevenueChartPainter extends CustomPainter {
  final Color lineColor;
  final Color fillColor;
  final Color labelColor;

  _RevenueChartPainter({
    required this.lineColor,
    required this.fillColor,
    required this.labelColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [fillColor, fillColor.withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final dotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    final dotOutlinePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.16, size.height * 0.72),
      Offset(size.width * 0.32, size.height * 0.78),
      Offset(size.width * 0.48, size.height * 0.62),
      Offset(size.width * 0.64, size.height * 0.58),
      Offset(size.width * 0.8, size.height * 0.45),
      Offset(size.width, size.height * 0.35),
    ];

    final path = Path()..moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final current = points[i];
      path.cubicTo(
        prev.dx + (current.dx - prev.dx) / 2,
        prev.dy,
        prev.dx + (current.dx - prev.dx) / 2,
        current.dy,
        current.dx,
        current.dy,
      );
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    for (final pt in points) {
      canvas.drawCircle(pt, 4.0, dotPaint);
      canvas.drawCircle(pt, 4.0, dotOutlinePaint);
    }

    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < points.length; i++) {
      textPainter.text = TextSpan(
        text: days[i],
        style: TextStyle(
          color: labelColor,
          fontSize: 9.sp,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(points[i].dx - 4.w, size.height + 6.h),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RevenueChartPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.labelColor != labelColor;
  }
}
