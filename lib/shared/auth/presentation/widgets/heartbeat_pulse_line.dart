import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

class HeartbeatPulseLine extends StatefulWidget {
  final double height;

  const HeartbeatPulseLine({
    super.key,
    this.height = 60,
  });

  @override
  State<HeartbeatPulseLine> createState() => _HeartbeatPulseLineState();
}

class _HeartbeatPulseLineState extends State<HeartbeatPulseLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: widget.height.h,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: ECGPainter(
              progress: _controller.value,
            ),
          );
        },
      ),
    );
  }
}

class ECGPainter extends CustomPainter {
  final double progress;

  ECGPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final midY = h / 2;

    // Define the normalized control points of the ECG wave (x: 0..1, y: 0..1)
    // The pulse area is centered between 0.4 and 0.6
    final List<math.Point<double>> basePoints = [
      const math.Point(0.0, 0.5),
      const math.Point(0.35, 0.5),
      const math.Point(0.38, 0.48), // small P wave bump
      const math.Point(0.40, 0.5),
      const math.Point(0.42, 0.52), // small Q wave dip
      const math.Point(0.45, 0.10), // high R wave spike
      const math.Point(0.48, 0.85), // deep S wave dip
      const math.Point(0.51, 0.35), // medium T wave bump
      const math.Point(0.54, 0.5),
      const math.Point(0.57, 0.48), // small U wave bump
      const math.Point(0.60, 0.5),
      const math.Point(1.0, 0.5),
    ];

    // Build the path
    final path = Path();
    path.moveTo(0, midY);

    // We can animate the spike amplitude based on a rhythmic heartbeat curve
    // Heartbeat double pulse sequence in 2 seconds
    double pulseScale = 1.0;
    final t = progress;
    if (t > 0.1 && t < 0.3) {
      // First beat (strong)
      pulseScale = 1.0 + 0.35 * math.sin((t - 0.1) / 0.2 * math.pi);
    } else if (t > 0.4 && t < 0.55) {
      // Second beat (weaker)
      pulseScale = 1.0 + 0.15 * math.sin((t - 0.4) / 0.15 * math.pi);
    }

    for (var i = 1; i < basePoints.length; i++) {
      final p = basePoints[i];
      final prevP = basePoints[i - 1];

      final x = p.x * w;
      double y = p.y * h;

      // Apply heartbeat scaling to the vertical spikes in the pulse region (0.35 to 0.60)
      if (p.x > 0.35 && p.x < 0.60) {
        final diffFromMid = y - midY;
        y = midY + diffFromMid * pulseScale;
      }

      // Smooth path using cubic curves or lines
      if (p.y == 0.5 && prevP.y == 0.5) {
        path.lineTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // 1. Draw the dim background heartbeat line
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..strokeWidth = 1.5.r
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, bgPaint);

    // 2. Draw the neon glow behind the active pulse
    // We create a traveling gradient paint along the line
    final pulseGlowPaint = Paint()
      ..strokeWidth = 4.0.r
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 5.0.r);

    // The glow travels from left to right
    final glowX = progress * w;
    final glowWidth = w * 0.25; // glow length is 25% of screen width

    pulseGlowPaint.shader = uiGradient(
      center: Offset(glowX, midY),
      width: glowWidth,
      glowColor: AppColors.primaryLight.withValues(alpha: 0.85),
    ).createShader(Rect.fromLTWH(glowX - glowWidth, 0, glowWidth * 2, h));
    canvas.drawPath(path, pulseGlowPaint);

    // 3. Draw the sharp bright core line in the center of the glow
    final corePaint = Paint()
      ..strokeWidth = 2.0.r
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    corePaint.shader = uiGradient(
      center: Offset(glowX, midY),
      width: glowWidth,
      glowColor: Colors.white,
      sideColor: Colors.white.withValues(alpha: 0.1),
    ).createShader(Rect.fromLTWH(glowX - glowWidth, 0, glowWidth * 2, h));
    canvas.drawPath(path, corePaint);

    // 4. Draw a bright sparkling dot at the front of the active wave
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      //..shadowColor = Colors.white
      ..imageFilter = null;
    
    // Find approximate Y coordinate of the dot along the path
    // We scan our points to interpolate the dot's current Y coordinate based on glowX
    double dotY = midY;
    for (var i = 1; i < basePoints.length; i++) {
      final p1 = basePoints[i - 1];
      final p2 = basePoints[i];
      final x1 = p1.x * w;
      final x2 = p2.x * w;
      if (glowX >= x1 && glowX <= x2) {
        final ratio = (glowX - x1) / (x2 - x1);
        double y1 = p1.y * h;
        double y2 = p2.y * h;
        if (p1.x > 0.35 && p1.x < 0.60) {
          y1 = midY + (y1 - midY) * pulseScale;
        }
        if (p2.x > 0.35 && p2.x < 0.60) {
          y2 = midY + (y2 - midY) * pulseScale;
        }
        dotY = y1 + ratio * (y2 - y1);
        break;
      }
    }

    canvas.drawCircle(Offset(glowX, dotY), 3.0.r, dotPaint);
  }

  LinearGradient uiGradient({
    required Offset center,
    required double width,
    required Color glowColor,
    Color? sideColor,
  }) {
    final edgeColor = sideColor ?? Colors.transparent;
    return LinearGradient(
      colors: [
        edgeColor,
        glowColor,
        edgeColor,
      ],
      begin: Alignment(
        ((center.dx - width) / center.dx).clamp(-1.0, 1.0),
        0,
      ),
      end: Alignment(
        ((center.dx + width) / center.dx).clamp(-1.0, 1.0),
        0,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant ECGPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
