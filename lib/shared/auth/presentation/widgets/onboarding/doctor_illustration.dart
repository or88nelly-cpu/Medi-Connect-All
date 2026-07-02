import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

class OnboardingDoctorIllustration extends StatefulWidget {
  const OnboardingDoctorIllustration({super.key});

  @override
  State<OnboardingDoctorIllustration> createState() =>
      _OnboardingDoctorIllustrationState();
}

class _OnboardingDoctorIllustrationState
    extends State<OnboardingDoctorIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnim;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _floatAnim = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOutSine),
      ),
    );

    _pulseAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
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
          // 1. Concentric Expanding Radar Waves
          AnimatedBuilder(
            animation: _pulseAnim,
            builder: (context, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  _buildRadarRing(_pulseAnim.value, delay: 0.0),
                  _buildRadarRing(_pulseAnim.value, delay: 0.33),
                  _buildRadarRing(_pulseAnim.value, delay: 0.66),
                ],
              );
            },
          ),

          // 2. Floating doctor/medical graphic
          AnimatedBuilder(
            animation: _floatAnim,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatAnim.value),
                child: child,
              );
            },
            child: Container(
              width: 120.r,
              height: 120.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  width: 3.r,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 24.r,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 100.r,
                  height: 100.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primaryLight,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(
                    Icons.supervisor_account_outlined,
                    color: Colors.white,
                    size: 48.r,
                  ),
                ),
              ),
            ),
          ),

          // 3. Mini floating health crosses around the main avatar
          Positioned(
            top: 25.h,
            left: 25.w,
            child: _buildFloatingPlus(
              delayFactor: 0.0,
              size: 14.r,
              color: AppColors.secondary,
            ),
          ),
          Positioned(
            bottom: 30.h,
            right: 20.w,
            child: _buildFloatingPlus(
              delayFactor: 0.5,
              size: 18.r,
              color: AppColors.primary,
            ),
          ),
          Positioned(
            top: 50.h,
            right: 35.w,
            child: _buildFloatingPlus(
              delayFactor: 0.25,
              size: 12.r,
              color: AppColors.primaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadarRing(double progress, {required double delay}) {
    double value = progress - delay;
    if (value < 0) value += 1.0;

    final scale = 1.0 + (value * 1.5);
    final opacity = (1.0 - value).clamp(0.0, 1.0);

    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity * 0.45,
        child: Container(
          width: 120.r,
          height: 120.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.35),
              width: 1.5.r,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingPlus({
    required double delayFactor,
    required double size,
    required Color color,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final localProgress = (_controller.value + delayFactor) % 1.0;
        final floatOffset = 8.0 * math.sin(localProgress * 2 * math.pi);
        final opacity = 0.3 + 0.7 * math.sin(localProgress * math.pi);

        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: Icon(
        Icons.add,
        size: size,
        color: color,
      ),
    );
  }
}
