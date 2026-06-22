import 'package:flutter/material.dart';

class CalendarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(10, 10, size.width - 20, size.height - 20),
      const Radius.circular(24),
    );

    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFE879F9), Color(0xFF7C3AED), Color(0xFF3B82F6)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Shadow
    canvas.drawShadow(
      Path()..addRRect(bodyRect),
      const Color(0xFF7C3AED),
      25,
      true,
    );

    // Main Body
    canvas.drawRRect(bodyRect, bodyPaint);

    // Glass Overlay
    canvas.drawRRect(
      bodyRect,
      Paint()..color = Colors.white.withValues(alpha: .08),
    );

    // Border
    canvas.drawRRect(
      bodyRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = Colors.white.withValues(alpha: .3),
    );

    // Top Header Shape
    final headerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * .22, 0, size.width * .56, size.height * .28),
      const Radius.circular(18),
    );

    canvas.drawRRect(
      headerRect,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFD946EF), Color(0xFF4F46E5)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
