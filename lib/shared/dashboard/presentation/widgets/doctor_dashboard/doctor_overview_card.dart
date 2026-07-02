import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class DoctorOverviewCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String count;
  final String subtitle;
  final String trend;
  final Color themeColor;
  final List<double> sparklineData;

  const DoctorOverviewCard({
    super.key,
    required this.icon,
    required this.title,
    required this.count,
    required this.subtitle,
    required this.trend,
    required this.themeColor,
    this.sparklineData = const [10, 14, 12, 18, 15, 22, 20],
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and Title
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      themeColor.withValues(alpha: 0.8),
                      themeColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 18.r,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isDark ? const Color(0xFF38BDF8) : themeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Count
          Text(
            count,
            style: AppTextStyles.headingLarge.copyWith(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w900,
              fontSize: 28.sp,
            ),
          ),
          SizedBox(height: 2.h),
          // Subtitle
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: isDark ? Colors.white38 : Colors.grey[500],
              fontSize: 10.sp,
            ),
          ),
          SizedBox(height: 12.h),
          // Sparkline + Trend Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Trend Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      color: themeColor,
                      size: 10.r,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      trend,
                      style: TextStyle(
                        color: themeColor,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Sparkline graph
              SizedBox(
                width: 60.w,
                height: 20.h,
                child: CustomPaint(
                  painter: _SparklinePainter(
                    data: sparklineData,
                    color: themeColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;

  _SparklinePainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final double maxVal = data.reduce((a, b) => a > b ? a : b);
    final double minVal = data.reduce((a, b) => a < b ? a : b);
    final double range = (maxVal - minVal) == 0 ? 1.0 : (maxVal - minVal);

    final double stepX = size.width / (data.length - 1);

    final path = Path();
    final fillPath = Path();

    double getX(int index) => index * stepX;
    double getY(double val) {
      final double normalized = (val - minVal) / range;
      // Invert Y because canvas origin is top-left
      return size.height - (normalized * (size.height - 4)) - 2;
    }

    path.moveTo(getX(0), getY(data[0]));
    fillPath.moveTo(getX(0), size.height);
    fillPath.lineTo(getX(0), getY(data[0]));

    for (int i = 1; i < data.length; i++) {
      final double x0 = getX(i - 1);
      final double y0 = getY(data[i - 1]);
      final double x1 = getX(i);
      final double y1 = getY(data[i]);
      
      // Control points for a smooth cubic bezier curve
      final double cx0 = x0 + (x1 - x0) / 2;
      final double cy0 = y0;
      final double cx1 = x0 + (x1 - x0) / 2;
      final double cy1 = y1;

      path.cubicTo(cx0, cy0, cx1, cy1, x1, y1);
      fillPath.cubicTo(cx0, cy0, cx1, cy1, x1, y1);
    }

    fillPath.lineTo(getX(data.length - 1), size.height);
    fillPath.close();

    // Draw the fill
    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withValues(alpha: 0.3),
          color.withValues(alpha: 0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);

    // Draw the stroke
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.r
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.color != color;
  }
}
