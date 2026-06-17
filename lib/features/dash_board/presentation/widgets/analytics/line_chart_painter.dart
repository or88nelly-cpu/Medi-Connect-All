import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';

class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final paintFill = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        colors: [
          AppColors.primary.withAlpha(64),
          AppColors.primary.withAlpha(0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final paintDot = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final paintDotBorder = Paint()
      ..color = AppColors.lightTextPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Simulated weekly revenue points
    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.16, size.height * 0.7),
      Offset(size.width * 0.33, size.height * 0.75),
      Offset(size.width * 0.5, size.height * 0.55),
      Offset(size.width * 0.66, size.height * 0.45),
      Offset(size.width * 0.83, size.height * 0.3),
      Offset(size.width, size.height * 0.2),
    ];

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      // Draw smooth cubic curves between points
      final pPrev = points[i - 1];
      final pCurrent = points[i];
      final controlPoint1 = Offset(
        pPrev.dx + (pCurrent.dx - pPrev.dx) / 2,
        pPrev.dy,
      );
      final controlPoint2 = Offset(
        pPrev.dx + (pCurrent.dx - pPrev.dx) / 2,
        pCurrent.dy,
      );
      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        pCurrent.dx,
        pCurrent.dy,
      );
    }

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, paintFill);
    canvas.drawPath(path, paintLine);

    // Draw point dots
    for (final pt in points) {
      canvas.drawCircle(pt, 5.0, paintDot);
      canvas.drawCircle(pt, 5.0, paintDotBorder);
    }

    // Draw X Axis labels (Mon-Sun)
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    for (int i = 0; i < points.length; i++) {
      textPainter.text = TextSpan(
        text: days[i],
        style: TextStyle(
          color: AppColors.lightTextSecondary,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(points[i].dx - 4.w, size.height + 4.h));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
