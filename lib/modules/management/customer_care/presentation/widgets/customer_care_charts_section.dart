import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class CustomerCareChartsSection extends StatelessWidget {
  final Map<String, dynamic> stats;

  const CustomerCareChartsSection({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    final lineData = List<double>.from(
      stats['registrations_trend_data'] ??
          [120.0, 132.0, 145.0, 160.0, 172.0, 153.0, 163.0, 200.0, 140.0],
    );
    final barData = List<double>.from(
      stats['appointments_trend_data'] ??
          [80.0, 95.0, 110.0, 105.0, 120.0, 115.0, 130.0, 150.0, 86.0],
    );
    final specialities = Map<String, double>.from(
      stats['specialities_data'] ??
          {
            'General Medicine': 320.0,
            'Orthopedics': 210.0,
            'Pediatrics': 180.0,
            'Dermatology': 150.0,
            'ENT': 120.0,
            'Cardiology': 90.0,
            'Others': 60.0,
          },
    );

    final labels = [
      "01 Jun",
      "03 Jun",
      "05 Jun",
      "07 Jun",
      "09 Jun",
      "11 Jun",
      "13 Jun",
      "15 Jun",
      "17 Jun",
    ];

    final cards = [
      _buildCardContainer(
        context,
        title: AppStrings.registrationsTrendDaily,
        action: _buildDropdown(context, AppStrings.lineChart),
        child: SizedBox(
          height: 180.h,
          child: CustomPaint(
            painter: _LineChartPainter(
              data: lineData,
              labels: labels,
              lineColor: const Color(0xFF0F6FFF),
              fillColor: const Color(0xFF0F6FFF).withValues(alpha: 0.15),
              textColor: AppColors.dashboardTextSecondary(context),
            ),
          ),
        ),
      ),
      _buildCardContainer(
        context,
        title: AppStrings.appointmentsTrendDaily,
        action: _buildDropdown(context, AppStrings.barChart),
        child: SizedBox(
          height: 180.h,
          child: CustomPaint(
            painter: _BarChartPainter(
              data: barData,
              labels: labels,
              barColor: const Color(0xFF7B61FF),
              textColor: AppColors.dashboardTextSecondary(context),
            ),
          ),
        ),
      ),
      _buildCardContainer(
        context,
        title: AppStrings.feedbackDistribution,
        child: _buildFeedbackDistribution(context),
      ),
      _buildCardContainer(
        context,
        title: AppStrings.visitsBySpeciality,
        action: _buildDropdown(context, AppStrings.sort),
        child: _buildVisitsBySpeciality(context, specialities),
      ),
    ];

    if (width < 750) {
      // Mobile layout: Stack vertically
      return Column(
        children: cards
            .map(
              (c) => Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: c,
              ),
            )
            .toList(),
      );
    } else if (width < 1350) {
      // Tablet layout: Grid of 2x2
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 1.3,
        children: cards,
      );
    } else {
      // Desktop layout: Row of 4 cards side-by-side
      return SizedBox(
        width: 1408.w,
        height: 300.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 27, child: cards[0]),
            SizedBox(width: 14.w),
            Expanded(flex: 25, child: cards[1]),
            SizedBox(width: 14.w),
            Expanded(flex: 23, child: cards[2]),
            SizedBox(width: 14.w),
            Expanded(flex: 25, child: cards[3]),
          ],
        ),
      );
    }
  }

  Widget _buildCardContainer(
    BuildContext context, {
    required String title,
    Widget? action,
    required Widget child,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final widgetBg = AppColors.dashboardCardBg(context);
    final borderColor = AppColors.dashboardCardBorder(context);
    final textColor = AppColors.dashboardTextPrimary(context);

    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: widgetBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.dashboardCardTitle.copyWith(
                    color: textColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ?action,
            ],
          ),
          SizedBox(height: 18.h),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildDropdown(BuildContext context, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = AppColors.dashboardTextPrimary(context);
    final borderColor = AppColors.dashboardCardBorder(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.black.withValues(alpha: 0.02),
        border: Border.all(color: borderColor, width: 1.2),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: AppTextStyles.bodyXSmall.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 4.w),
          Icon(Icons.keyboard_arrow_down_rounded, size: 14.r, color: textColor),
        ],
      ),
    );
  }

  Widget _buildFeedbackDistribution(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = AppColors.dashboardTextPrimary(context);
    final labelColor = AppColors.dashboardTextSecondary(context);

    final double excellent =
        (stats['feedback_excellent_pct'] as num?)?.toDouble() ?? 72.0;
    final double good =
        (stats['feedback_good_pct'] as num?)?.toDouble() ?? 18.0;
    final double average =
        (stats['feedback_average_pct'] as num?)?.toDouble() ?? 7.0;
    final double poor = (stats['feedback_poor_pct'] as num?)?.toDouble() ?? 3.0;

    final int excellentCount =
        (stats['feedback_excellent_count'] as num?)?.toInt() ?? 896;
    final int goodCount =
        (stats['feedback_good_count'] as num?)?.toInt() ?? 224;
    final int averageCount =
        (stats['feedback_average_count'] as num?)?.toInt() ?? 87;
    final int poorCount = (stats['feedback_poor_count'] as num?)?.toInt() ?? 38;

    final int total = (stats['feedback_total'] as num?)?.toInt() ?? 1245;

    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              // Donut Chart
              Expanded(
                flex: 4,
                child: Center(
                  child: SizedBox(
                    width: 100.r,
                    height: 100.r,
                    child: CustomPaint(
                      painter: _DonutChartPainter(
                        slices: [
                          _PieSlice(excellent, const Color(0xFF22C55E)),
                          _PieSlice(good, const Color(0xFF0F6FFF)),
                          _PieSlice(average, const Color(0xFFFF8A26)),
                          _PieSlice(poor, const Color(0xFFEF4444)),
                        ],
                        totalText: "$total",
                        labelText: "Feedbacks",
                        textColor: textColor,
                        labelColor: labelColor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              // Legend
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _legendItem(
                      AppStrings.excellent,
                      excellent.toInt(),
                      excellentCount,
                      const Color(0xFF22C55E),
                      textColor,
                    ),
                    SizedBox(height: 6.h),
                    _legendItem(
                      "Good",
                      good.toInt(),
                      goodCount,
                      const Color(0xFF0F6FFF),
                      textColor,
                    ),
                    SizedBox(height: 6.h),
                    _legendItem(
                      AppStrings.average,
                      average.toInt(),
                      averageCount,
                      const Color(0xFFFF8A26),
                      textColor,
                    ),
                    SizedBox(height: 6.h),
                    _legendItem(
                      AppStrings.poor,
                      poor.toInt(),
                      poorCount,
                      const Color(0xFFEF4444),
                      textColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        // Average Rating card
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.02)
                : Colors.black.withValues(alpha: 0.015),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: AppColors.dashboardCardBorder(context),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: const Color(0xFFFF8A26),
                    size: 18.r,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    AppStrings.averageRating,
                    style: AppTextStyles.bodyXSmall.copyWith(
                      color: labelColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    "${stats['feedback_score']?.toString() ?? '4.7'} / 5",
                    style: AppTextStyles.bodySmall.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                "${stats['feedback_score_trend']?.toString() ?? '+0.4'} vs last period",
                style: AppTextStyles.bodyXSmall.copyWith(
                  color: const Color(0xFF22C55E),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _legendItem(
    String label,
    int pct,
    int count,
    Color color,
    Color textColor,
  ) {
    return Row(
      children: [
        Container(
          width: 8.r,
          height: 8.r,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: AppTextStyles.bodyXSmall.copyWith(
            color: textColor.withValues(alpha: 0.8),
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Text(
          "$pct% ($count)",
          style: AppTextStyles.bodyXSmall.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildVisitsBySpeciality(
    BuildContext context,
    Map<String, double> data,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = AppColors.dashboardTextPrimary(context);
    final labelColor = AppColors.dashboardTextSecondary(context);

    double maxVal = 1.0;
    if (data.isNotEmpty) {
      maxVal = data.values.reduce(math.max);
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final key = data.keys.elementAt(index);
        final val = data[key] ?? 0.0;
        final ratio = maxVal > 0 ? (val / maxVal) : 0.0;

        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Row(
            children: [
              SizedBox(
                width: 100.w,
                child: Text(
                  key,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyXSmall.copyWith(
                    color: labelColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.black.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: ratio,
                      child: Container(
                        height: 10.h,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0F6FFF), Color(0xFF5A9CFF)],
                          ),
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              SizedBox(
                width: 30.w,
                child: Text(
                  val.toInt().toString(),
                  textAlign: Alignment.centerRight.x == 1.0
                      ? TextAlign.end
                      : TextAlign.right,
                  style: AppTextStyles.bodyXSmall.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final Color lineColor;
  final Color fillColor;
  final Color textColor;

  _LineChartPainter({
    required this.data,
    required this.labels,
    required this.lineColor,
    required this.fillColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final chartHeight = size.height - 24.h;
    final chartWidth = size.width;

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
      ).createShader(Rect.fromLTWH(0, 0, chartWidth, chartHeight));

    double maxVal = data.reduce(math.max);
    if (maxVal <= 0.0) maxVal = 100.0;

    final double stepX = chartWidth / (data.length - 1);
    final List<Offset> points = [];

    for (int i = 0; i < data.length; i++) {
      final double x = i * stepX;
      // Map value to 10% to 90% of chartHeight
      final double y =
          chartHeight - (data[i] / maxVal) * (chartHeight * 0.7) - 10;
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
      ..lineTo(chartWidth, chartHeight)
      ..lineTo(0, chartHeight)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    // Draw dots and points value text
    final dotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;
    final dotOutlinePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], 4.0, dotPaint);
      canvas.drawCircle(points[i], 4.0, dotOutlinePaint);

      // Draw value text above dot (every 2nd point to avoid overlap on mobile)
      if (i % 2 == 0 || size.width > 300) {
        textPainter.text = TextSpan(
          text: data[i].toInt().toString(),
          style: TextStyle(
            color: textColor,
            fontSize: 8.sp,
            fontWeight: FontWeight.bold,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(points[i].dx - textPainter.width / 2, points[i].dy - 16.h),
        );
      }
    }

    // Draw axis labels at the bottom
    for (int i = 0; i < labels.length; i++) {
      if (i % 2 == 0 || size.width > 300) {
        textPainter.text = TextSpan(
          text: labels[i],
          style: TextStyle(
            color: textColor.withValues(alpha: 0.6),
            fontSize: 8.sp,
            fontWeight: FontWeight.bold,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(i * stepX - textPainter.width / 2, chartHeight + 8.h),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.lineColor != lineColor;
  }
}

class _BarChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final Color barColor;
  final Color textColor;

  _BarChartPainter({
    required this.data,
    required this.labels,
    required this.barColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final chartHeight = size.height - 24.h;
    final chartWidth = size.width;

    double maxVal = data.reduce(math.max);
    if (maxVal <= 0.0) maxVal = 100.0;

    final double stepX = chartWidth / data.length;
    final double barWidth = stepX * 0.55;

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [barColor, barColor.withValues(alpha: 0.4)],
      ).createShader(Rect.fromLTWH(0, 0, chartWidth, chartHeight));

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < data.length; i++) {
      final double x = i * stepX + (stepX - barWidth) / 2;
      final double h = (data[i] / maxVal) * (chartHeight * 0.7);
      final double y = chartHeight - h;

      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(x, y, barWidth, h),
        topLeft: Radius.circular(4.r),
        topRight: Radius.circular(4.r),
      );

      canvas.drawRRect(rect, paint);

      // Draw value text above bar
      if (i % 2 == 0 || size.width > 300) {
        textPainter.text = TextSpan(
          text: data[i].toInt().toString(),
          style: TextStyle(
            color: textColor,
            fontSize: 8.sp,
            fontWeight: FontWeight.bold,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x + barWidth / 2 - textPainter.width / 2, y - 14.h),
        );
      }

      // Draw axis label
      if (i % 2 == 0 || size.width > 300) {
        textPainter.text = TextSpan(
          text: labels[i],
          style: TextStyle(
            color: textColor.withValues(alpha: 0.6),
            fontSize: 8.sp,
            fontWeight: FontWeight.bold,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x + barWidth / 2 - textPainter.width / 2, chartHeight + 8.h),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.barColor != barColor;
  }
}

class _PieSlice {
  final double value;
  final Color color;
  _PieSlice(this.value, this.color);
}

class _DonutChartPainter extends CustomPainter {
  final List<_PieSlice> slices;
  final String totalText;
  final String labelText;
  final Color textColor;
  final Color labelColor;

  _DonutChartPainter({
    required this.slices,
    required this.totalText,
    required this.labelText,
    required this.textColor,
    required this.labelColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double totalValue = slices
        .map((s) => s.value)
        .reduce((a, b) => a + b);
    if (totalValue <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final strokeWidth = radius * 0.28;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    double startAngle = -math.pi / 2;

    for (final slice in slices) {
      final sweepAngle = (slice.value / totalValue) * 2 * math.pi;
      paint.color = slice.color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      startAngle += sweepAngle;
    }

    // Draw center text
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Dynamic sizing based on size
    textPainter.text = TextSpan(
      children: [
        TextSpan(
          text: "$totalText\n",
          style: TextStyle(
            color: textColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        TextSpan(
          text: labelText.toUpperCase(),
          style: TextStyle(
            color: labelColor,
            fontSize: 7.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.slices != slices || oldDelegate.totalText != totalText;
  }
}
