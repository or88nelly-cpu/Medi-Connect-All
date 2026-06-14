import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class WeeklyRevenueTrendCard extends StatelessWidget {
  final double weeklyRevenue;
  final List<double> dailyRevenues;

  const WeeklyRevenueTrendCard({
    super.key,
    required this.weeklyRevenue,
    required this.dailyRevenues,
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
            "₹ ${weeklyRevenue.toStringAsFixed(2)}",
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
                dailyRevenues: dailyRevenues,
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
  final List<double> dailyRevenues;

  _RevenueChartPainter({
    required this.lineColor,
    required this.fillColor,
    required this.labelColor,
    required this.dailyRevenues,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dailyRevenues.isEmpty) return;

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

    double maxVal = dailyRevenues.reduce((a, b) => a > b ? a : b);
    if (maxVal <= 0.0) maxVal = 100.0;

    final List<Offset> points = [];
    final double stepX = size.width / (dailyRevenues.length - 1);
    for (int i = 0; i < dailyRevenues.length; i++) {
      final double x = i * stepX;
      // Normalizing values: map 0 to maxVal onto height * 0.85 to height * 0.15
      final double y = size.height * 0.85 - (dailyRevenues[i] / maxVal) * (size.height * 0.7);
      points.add(Offset(x, y));
    }

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

    // Days labels (e.g. last 7 days of week, ending with today)
    final List<String> days = [];
    for (int i = 6; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: i));
      days.add(DateFormat('E').format(date).substring(0, 1));
    }

    final textPainter = TextPainter();

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
        oldDelegate.labelColor != labelColor ||
        oldDelegate.dailyRevenues != dailyRevenues;
  }
}
