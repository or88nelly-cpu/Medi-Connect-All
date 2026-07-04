import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

// --- ADMIN ANALYTICS SECTION ---
class EmrdAdminAnalyticsSection extends StatelessWidget {
  final Map<String, dynamic> stats;
  final bool isDark;

  const EmrdAdminAnalyticsSection({
    super.key,
    required this.stats,
    required this.isDark,
  });

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10.r,
          height: 10.r,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.terminalDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? Colors.white10 : AppColors.border(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insights, color: AppColors.primary, size: 20.r),
              SizedBox(width: 10.w),
              Text(
                "EMRD Performance & Trend Analytics",
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                  color: isDark ? Colors.white : AppColors.textPrimary(context),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            "Visual trend analysis for digitization rate and storage utilization",
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 11.sp,
              color: isDark ? Colors.white30 : AppColors.textSecondary(context),
            ),
          ),
          SizedBox(height: 20.h),

          SizedBox(
            height: 150.h,
            width: double.infinity,
            child: CustomPaint(
              painter: EMRDAnalyticsPainter(
                values: [45.0, 58.0, 72.0, 68.0, 85.0, 92.0],
                labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
                primaryColor: const Color(0xFF6366F1),
                secondaryColor: const Color(0xFF10B981),
                isDark: isDark,
              ),
            ),
          ),
          SizedBox(height: 18.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(
                "Digitization Accuracy (%)",
                const Color(0xFF6366F1),
              ),
              SizedBox(width: 20.w),
              _buildLegendItem(
                "Storage Optimization (%)",
                const Color(0xFF10B981),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EMRDAnalyticsPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;
  final Color primaryColor;
  final Color secondaryColor;
  final bool isDark;

  EMRDAnalyticsPainter({
    required this.values,
    required this.labels,
    required this.primaryColor,
    required this.secondaryColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintGrid = Paint()
      ..color = isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    final paintLine = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final paintLine2 = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()..style = PaintingStyle.fill;

    const rows = 4;
    for (int i = 0; i <= rows; i++) {
      final y = size.height * (i / rows);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paintGrid);
    }

    final double stepX = size.width / (values.length - 1);
    final double maxVal = 100.0;

    final path = Path();
    final fillPath = Path();

    final path2 = Path();
    final fillPath2 = Path();

    for (int i = 0; i < values.length; i++) {
      final x = i * stepX;
      final y = size.height - (values[i] / maxVal) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      if (i == values.length - 1) {
        fillPath.lineTo(x, size.height);
        fillPath.close();
      }
    }

    final List<double> values2 = [60, 68, 70, 75, 78, 85];
    for (int i = 0; i < values2.length; i++) {
      final x = i * stepX;
      final y = size.height - (values2[i] / maxVal) * size.height;

      if (i == 0) {
        path2.moveTo(x, y);
        fillPath2.moveTo(x, size.height);
        fillPath2.lineTo(x, y);
      } else {
        path2.lineTo(x, y);
        fillPath2.lineTo(x, y);
      }

      if (i == values2.length - 1) {
        fillPath2.lineTo(x, size.height);
        fillPath2.close();
      }
    }

    final gradient = LinearGradient(
      colors: [
        primaryColor.withValues(alpha: 0.3),
        primaryColor.withValues(alpha: 0.0),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    fillPaint.shader = gradient.createShader(
      Rect.fromLTWH(0, 0, size.width, size.height),
    );
    canvas.drawPath(fillPath, fillPaint);

    final gradient2 = LinearGradient(
      colors: [
        secondaryColor.withValues(alpha: 0.2),
        secondaryColor.withValues(alpha: 0.0),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    final fillPaint2 = Paint()
      ..style = PaintingStyle.fill
      ..shader = gradient2.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    canvas.drawPath(fillPath2, fillPaint2);

    canvas.drawPath(path, paintLine);
    canvas.drawPath(path2, paintLine2);

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < values.length; i++) {
      final x = i * stepX;
      final y = size.height - (values[i] / maxVal) * size.height;

      canvas.drawCircle(Offset(x, y), 5, Paint()..color = primaryColor);
      canvas.drawCircle(Offset(x, y), 3, Paint()..color = Colors.white);

      final y2 = size.height - (values2[i] / maxVal) * size.height;
      canvas.drawCircle(Offset(x, y2), 5, Paint()..color = secondaryColor);
      canvas.drawCircle(Offset(x, y2), 3, Paint()..color = Colors.white);

      textPainter.text = TextSpan(
        text: labels[i],
        style: TextStyle(
          color: isDark ? Colors.white30 : Colors.black38,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height + 6),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
