import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

class OnboardingSecurityIllustration extends StatefulWidget {
  const OnboardingSecurityIllustration({super.key});

  @override
  State<OnboardingSecurityIllustration> createState() =>
      _OnboardingSecurityIllustrationState();
}

class _OnboardingSecurityIllustrationState
    extends State<OnboardingSecurityIllustration>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _rotateController;
  late Animation<double> _floatAnim;
  late Animation<double> _rotationClockwise;
  late Animation<double> _rotationCounterClockwise;

  @override
  void initState() {
    super.initState();
    
    // Float animation controller (for center card)
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _floatController,
        curve: Curves.easeInOutQuad,
      ),
    );

    // Rotation animation controller (for outer orbital rings)
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _rotationClockwise = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.linear),
    );

    _rotationCounterClockwise = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _rotateController.dispose();
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
          // 1. Outer Orbit Ring (Clockwise)
          RotationTransition(
            turns: _rotationClockwise,
            child: Container(
              width: 200.r,
              height: 200.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  width: 1.5.r,
                  style: BorderStyle.solid,
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -6.r,
                    left: 94.r, // Centered horizontally
                    child: Container(
                      width: 12.r,
                      height: 12.r,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 4.r,
                          height: 4.r,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Inner Orbit Ring (Counter-Clockwise)
          RotationTransition(
            turns: _rotationCounterClockwise,
            child: Container(
              width: 156.r,
              height: 156.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.15),
                  width: 1.2.r,
                  style: BorderStyle.solid,
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    bottom: -5.r,
                    left: 73.r, // Centered horizontally
                    child: Container(
                      width: 10.r,
                      height: 10.r,
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Central Security Shield Avatar
          AnimatedBuilder(
            animation: _floatAnim,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatAnim.value),
                child: child,
              );
            },
            child: Container(
              width: 110.r,
              height: 110.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  width: 3.r,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    blurRadius: 20.r,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 90.r,
                  height: 90.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primaryLight,
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          color: Colors.white,
                          size: 44.r,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: Icon(
                            Icons.lock_outline,
                            color: AppColors.secondary,
                            size: 18.r,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
