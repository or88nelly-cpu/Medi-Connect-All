import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class AppointmentSummaryGraphCard extends StatelessWidget {
  const AppointmentSummaryGraphCard({super.key});

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
          Text(
            AppStrings.appointmentSummaryGraph,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            AppStrings.weeklyConsultationAppointments,
            style: AppTextStyles.bodySmall.copyWith(
              color: labelColor,
              fontSize: 11.sp,
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 120.h,
            width: double.infinity,
            child: CustomPaint(
              painter: _AppointmentTrendPainter(
                lineColor: AppColors.secondary,
                fillColor: AppColors.secondary.withOpacity(0.15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentTrendPainter extends CustomPainter {
  final Color lineColor;
  final Color fillColor;

  _AppointmentTrendPainter({
    required this.lineColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [fillColor, fillColor.withOpacity(0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.2, size.height * 0.75),
      Offset(size.width * 0.4, size.height * 0.65),
      Offset(size.width * 0.6, size.height * 0.45),
      Offset(size.width * 0.8, size.height * 0.35),
      Offset(size.width, size.height * 0.38),
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
  }

  @override
  bool shouldRepaint(covariant _AppointmentTrendPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor || oldDelegate.fillColor != fillColor;
  }
}
