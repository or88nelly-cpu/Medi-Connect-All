import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

class FloatingConnectingIcons extends StatefulWidget {
  final double top;
  final double right;

  const FloatingConnectingIcons({
    super.key,
    required this.top,
    required this.right,
  });

  @override
  State<FloatingConnectingIcons> createState() => _FloatingConnectingIconsState();
}

class _FloatingConnectingIconsState extends State<FloatingConnectingIcons>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      right: widget.right,
      child: AnimatedBuilder(
        animation: _floatAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: child,
          );
        },
        child: SizedBox(
          width: 140.w,
          height: 270.h,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Dashed connecting line
              Positioned.fill(
                child: CustomPaint(
                  painter: DashedCurvePainter(),
                ),
              ),

              // Top circle: Stethoscope
              Positioned(
                top: 15.h,
                right: 15.w,
                child: _buildCircularIcon(
                  Icons.medical_services_outlined,
                  delayMs: 0,
                ),
              ),

              // Middle circle: People
              Positioned(
                top: 105.h,
                right: 50.w,
                child: _buildCircularIcon(
                  Icons.people_alt_outlined,
                  delayMs: 200,
                ),
              ),

              // Bottom circle: Hospital
              Positioned(
                top: 195.h,
                right: 15.w,
                child: _buildCircularIcon(
                  Icons.local_hospital_outlined,
                  delayMs: 400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularIcon(IconData icon, {required int delayMs}) {
    return Container(
      width: 50.r,
      height: 50.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(alpha: 0.08),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1.2.r,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.12),
            blurRadius: 10.r,
            spreadRadius: 1.r,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 24.r,
        ),
      ),
    );
  }
}

class DashedCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.25)
      ..strokeWidth = 1.2.r
      ..style = PaintingStyle.stroke;

    // Define control points based on the child icon positions
    final p1 = Offset(size.width - 40.w, 40.h);
    final pc = Offset(size.width - 100.w, 130.h);
    final p2 = Offset(size.width - 40.w, 220.h);

    final segments = 50;
    bool draw = true;
    Offset? prevPoint;
    for (int i = 0; i <= segments; i++) {
      final t = i / segments;
      // Quadratic Bezier formula
      final dx = (1 - t) * (1 - t) * p1.dx + 2 * (1 - t) * t * pc.dx + t * t * p2.dx;
      final dy = (1 - t) * (1 - t) * p1.dy + 2 * (1 - t) * t * pc.dy + t * t * p2.dy;
      final point = Offset(dx, dy);

      if (i > 0 && draw) {
        canvas.drawLine(prevPoint!, point, paint);
      }
      // Toggle drawing every segment to make a dashed pattern
      if (i % 2 == 0) {
        draw = !draw;
      }
      prevPoint = point;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
