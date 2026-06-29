import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackgroundAccentPainter extends CustomPainter {
  final Color lineColor;
  final Color dotColor;

  BackgroundAccentPainter({required this.lineColor, required this.dotColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final center = Offset(size.width * 0.9, size.height * 0.08);
    final radius = 220.w;

    canvas.drawCircle(center, radius, paint);

    final dotPaint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    const double angle = 210 * math.pi / 180;
    final dotCenter = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );

    canvas.drawCircle(dotCenter, 4.w, dotPaint);
  }

  @override
  bool shouldRepaint(covariant BackgroundAccentPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.dotColor != dotColor;
  }
}
