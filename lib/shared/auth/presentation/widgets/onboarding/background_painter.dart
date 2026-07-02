import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

class OnboardingBackground extends StatelessWidget {
  final Widget child;

  const OnboardingBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.background(context),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: BackgroundWavePainter(isDark: AppColors.isDark(context)),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class BackgroundWavePainter extends CustomPainter {
  final bool isDark;

  BackgroundWavePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final w = size.width;
    final h = size.height;

    // 1. Draw top-right wave
    final pathTop = Path();
    pathTop.moveTo(w * 0.3, 0);
    pathTop.quadraticBezierTo(w * 0.6, h * 0.12, w, h * 0.06);
    pathTop.lineTo(w, 0);
    pathTop.close();

    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.primary.withValues(alpha: isDark ? 0.06 : 0.08),
        AppColors.primaryLight.withValues(alpha: 0.01),
      ],
    ).createShader(Rect.fromLTWH(w * 0.3, 0, w * 0.7, h * 0.12));
    canvas.drawPath(pathTop, paint);

    // 2. Draw second layered top-right wave for depth
    final pathTop2 = Path();
    pathTop2.moveTo(w * 0.45, 0);
    pathTop2.quadraticBezierTo(w * 0.7, h * 0.16, w, h * 0.10);
    pathTop2.lineTo(w, 0);
    pathTop2.close();

    paint.shader = LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [
        AppColors.primaryLight.withValues(alpha: isDark ? 0.04 : 0.05),
        AppColors.primary.withValues(alpha: 0.01),
      ],
    ).createShader(Rect.fromLTWH(w * 0.45, 0, w * 0.55, h * 0.16));
    canvas.drawPath(pathTop2, paint);

    // 3. Draw bottom-left wave
    final pathBottom = Path();
    pathBottom.moveTo(0, h * 0.88);
    pathBottom.quadraticBezierTo(w * 0.35, h * 0.82, w * 0.75, h);
    pathBottom.lineTo(0, h);
    pathBottom.close();

    paint.shader = LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        AppColors.primary.withValues(alpha: isDark ? 0.06 : 0.08),
        AppColors.primaryDark.withValues(alpha: 0.01),
      ],
    ).createShader(Rect.fromLTWH(0, h * 0.82, w * 0.75, h * 0.18));
    canvas.drawPath(pathBottom, paint);

    // 4. Draw second layered bottom-left wave for depth
    final pathBottom2 = Path();
    pathBottom2.moveTo(0, h * 0.80);
    pathBottom2.quadraticBezierTo(w * 0.42, h * 0.88, w * 0.6, h);
    pathBottom2.lineTo(0, h);
    pathBottom2.close();

    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.primaryLight.withValues(alpha: isDark ? 0.03 : 0.04),
        AppColors.primary.withValues(alpha: 0.01),
      ],
    ).createShader(Rect.fromLTWH(0, h * 0.80, w * 0.6, h * 0.20));
    canvas.drawPath(pathBottom2, paint);

    // 5. Draw decorative medical plus shapes in background
    final crossPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: isDark ? 0.04 : 0.06)
      ..strokeWidth = 2.0.r
      ..style = PaintingStyle.stroke;
    
    _drawCross(canvas, Offset(w * 0.85, h * 0.22), 8.r, crossPaint);
    _drawCross(canvas, Offset(w * 0.15, h * 0.72), 10.r, crossPaint);
    _drawCross(canvas, Offset(w * 0.1, h * 0.18), 6.r, crossPaint);
  }

  void _drawCross(Canvas canvas, Offset center, double size, Paint paint) {
    canvas.drawLine(Offset(center.dx - size, center.dy), Offset(center.dx + size, center.dy), paint);
    canvas.drawLine(Offset(center.dx, center.dy - size), Offset(center.dx, center.dy + size), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
