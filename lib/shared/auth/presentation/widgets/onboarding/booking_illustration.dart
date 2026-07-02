import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

class OnboardingBookingIllustration extends StatefulWidget {
  const OnboardingBookingIllustration({super.key});

  @override
  State<OnboardingBookingIllustration> createState() =>
      _OnboardingBookingIllustrationState();
}

class _OnboardingBookingIllustrationState
    extends State<OnboardingBookingIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnim;
  late Animation<double> _rotationAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    _floatAnim = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOutSine),
      ),
    );

    _rotationAnim = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260.r,
      height: 260.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Background glow radial pulse
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final scale = 1.0 + 0.08 * math.sin(_controller.value * 2 * math.pi);
              return Container(
                width: 190.r * scale,
                height: 190.r * scale,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.04),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.06),
                      blurRadius: 30.r,
                      spreadRadius: 5.r,
                    ),
                  ],
                ),
              );
            },
          ),

          // 2. Floating Calendar Grid Card
          AnimatedBuilder(
            animation: _floatAnim,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatAnim.value),
                child: child,
              );
            },
            child: Container(
              width: 140.r,
              height: 140.r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: Colors.white,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  width: 1.5.r,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    blurRadius: 20.r,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Column(
                  children: [
                    // Calendar Header
                    Container(
                      height: 34.h,
                      color: AppColors.primary,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 6.r,
                            height: 6.r,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 32.w,
                            height: 6.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                          ),
                          Container(
                            width: 6.r,
                            height: 6.r,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Calendar Days Grid Mock
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(10.r),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 6.r,
                            mainAxisSpacing: 6.r,
                          ),
                          itemCount: 20,
                          itemBuilder: (context, index) {
                            // Highlight 3 items in primary and secondary colors
                            Color itemColor = Colors.grey.withValues(alpha: 0.15);
                            if (index == 7) itemColor = AppColors.secondary;
                            if (index == 12) itemColor = AppColors.primaryLight;
                            if (index == 13) itemColor = AppColors.primary;

                            return Container(
                              decoration: BoxDecoration(
                                color: itemColor,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Glowing Clock and Sweeping needle overlaid on bottom-right of the card
          Positioned(
            bottom: 35.h,
            right: 35.w,
            child: AnimatedBuilder(
              animation: _rotationAnim,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _floatAnim.value * 0.4),
                  child: Container(
                    width: 72.r,
                    height: 72.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: AppColors.primaryLight.withValues(alpha: 0.25),
                        width: 2.r,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryLight.withValues(alpha: 0.15),
                          blurRadius: 10.r,
                          spreadRadius: 1.r,
                        ),
                      ],
                    ),
                    child: CustomPaint(
                      painter: ClockNeedlePainter(
                        angle: _rotationAnim.value,
                        needleColor: AppColors.primary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ClockNeedlePainter extends CustomPainter {
  final double angle;
  final Color needleColor;

  ClockNeedlePainter({
    required this.angle,
    required this.needleColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw clock ticks
    final tickPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..strokeWidth = 1.5.r
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 12; i++) {
      final tickAngle = i * (2 * math.pi / 12);
      final outerPoint = Offset(
        center.dx + (radius - 4.r) * math.cos(tickAngle),
        center.dy + (radius - 4.r) * math.sin(tickAngle),
      );
      final innerPoint = Offset(
        center.dx + (radius - 8.r) * math.cos(tickAngle),
        center.dy + (radius - 8.r) * math.sin(tickAngle),
      );
      canvas.drawLine(innerPoint, outerPoint, tickPaint);
    }

    // Draw clock center dot
    final centerPaint = Paint()
      ..color = needleColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 3.5.r, centerPaint);

    // Draw clock hands (sweeping second hand)
    final needlePaint = Paint()
      ..color = needleColor
      ..strokeWidth = 2.0.r
      ..strokeCap = StrokeCap.round;

    final endPoint = Offset(
      center.dx + (radius - 12.r) * math.cos(angle - math.pi / 2),
      center.dy + (radius - 12.r) * math.sin(angle - math.pi / 2),
    );
    canvas.drawLine(center, endPoint, needlePaint);

    // Hour hand (fixed/slow moving representation)
    final hourPaint = Paint()
      ..color = needleColor.withValues(alpha: 0.6)
      ..strokeWidth = 3.0.r
      ..strokeCap = StrokeCap.round;
    
    final hourAngle = angle / 12 - math.pi / 6;
    final hourEnd = Offset(
      center.dx + (radius - 18.r) * math.cos(hourAngle - math.pi / 2),
      center.dy + (radius - 18.r) * math.sin(hourAngle - math.pi / 2),
    );
    canvas.drawLine(center, hourEnd, hourPaint);
  }

  @override
  bool shouldRepaint(covariant ClockNeedlePainter oldDelegate) {
    return oldDelegate.angle != angle;
  }
}
