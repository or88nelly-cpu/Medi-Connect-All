import 'package:flutter/material.dart';

class CustomLineChartPainter extends CustomPainter {
  final Color lineColor;
  final Color shadowColor;
  final double strokeWidth;

  CustomLineChartPainter({
    required this.lineColor,
    required this.shadowColor,
    this.strokeWidth = 3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          shadowColor.withValues(alpha: 0.3),
          shadowColor.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.15, size.height * 0.65),
      Offset(size.width * 0.30, size.height * 0.72),
      Offset(size.width * 0.50, size.height * 0.45),
      Offset(size.width * 0.70, size.height * 0.35),
      Offset(size.width * 0.85, size.height * 0.25),
      Offset(size.width, size.height * 0.15),
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
  bool shouldRepaint(covariant CustomLineChartPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.shadowColor != shadowColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
