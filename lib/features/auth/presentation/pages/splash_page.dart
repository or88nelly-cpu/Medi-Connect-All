/// Splash page shown on app launch.
/// Displays a premium heartbeat pulse, concentric cardiac pulse waves, rotating sync animation,
/// and floating interactive medical crosses. Verifies auth state and routes.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/router/route_names.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/utils/constants/app_assets.dart';
import 'package:medi_connect/core/utils/constants/app_fonts.dart';

import '../bloc/auth_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _pulseRingController;
  late AnimationController _rotateController;
  late AnimationController _textController;
  late AnimationController _bgController;

  // Animation definitions
  late Animation<double> _iconScale;
  late Animation<double> _rotation;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _bottomLoaderFade;
  late Animation<double> _bgScale;

  @override
  void initState() {
    super.initState();

    // 1. Ken Burns background zoom (one shot)
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );
    _bgScale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _bgController, curve: Curves.easeOutCubic),
    );
    _bgController.forward();

    // 2. Concentric expanding rings progress (repeats)
    _pulseRingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    // 3. Heartbeat pulse animation (repeats)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _iconScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.15,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.15,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.08,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.08,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
    ]).animate(_pulseController);

    // 4. Continuous rotation scanning animation (repeats)
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _rotation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.1415926535,
    ).animate(CurvedAnimation(parent: _rotateController, curve: Curves.linear));

    // 5. Text & Bottom loading slide-in animation (one shot)
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );
    _textSlide = Tween<Offset>(begin: const Offset(0.0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _textController,
            curve: const Interval(0.2, 0.9, curve: Curves.easeOutCubic),
          ),
        );
    _bottomLoaderFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    _textController.forward();

    // Trigger auth session verification.
    context.read<AuthBloc>().add(AuthCheckRequested());
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _pulseRingController.dispose();
    _rotateController.dispose();
    _textController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWebOrDesktop =
        kIsWeb ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux;
    final bgImage = isWebOrDesktop
        ? AppAssets.splashBgWebPng
        : AppAssets.splashBgMobPng;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        // Wait to show the beautiful premium animations before navigating.
        await Future.delayed(const Duration(milliseconds: 2800));
        if (state is Authenticated) {
          final role = state.user.role;
          if (mounted) {
            context.go('/$role/dashboard');
          }
        } else if (state is Unauthenticated) {
          if (mounted) {
            context.go(RouteNames.onboarding);
          }
        }
      },
      child: Scaffold(
        body: ClipRect(
          child: Stack(
            children: [
              // 1. Ken Burns background zoom
              ScaleTransition(
                scale: _bgScale,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(bgImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // 2. Corner Parallax Floating Crosses (adds depth to background layout)
              const FloatingMedicalCross(
                top: 130,
                left: 45,
                size: 26,
                color: AppColors.primaryOpacity20,
                duration: Duration(milliseconds: 2400),
              ),
              const FloatingMedicalCross(
                bottom: 220,
                right: 35,
                size: 28,
                color: AppColors.primaryOpacity13,
                duration: Duration(milliseconds: 2800),
              ),
              const FloatingMedicalCross(
                top: 280,
                right: 40,
                size: 20,
                color: AppColors.primaryOpacity12,
                duration: Duration(milliseconds: 2000),
              ),
              const FloatingMedicalCross(
                bottom: 160,
                left: 60,
                size: 24,
                color: AppColors.primaryOpacity16,
                duration: Duration(milliseconds: 2600),
              ),

              // 3. Central Animations & Logo
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // A. Expanding pulse wave rings behind the logo
                        AnimatedBuilder(
                          animation: _pulseRingController,
                          builder: (context, _) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                AnimatedPulseRing(
                                  progress: _pulseRingController,
                                  delay: 0.0,
                                ),
                                AnimatedPulseRing(
                                  progress: _pulseRingController,
                                  delay: 0.33,
                                ),
                                AnimatedPulseRing(
                                  progress: _pulseRingController,
                                  delay: 0.66,
                                ),
                              ],
                            );
                          },
                        ),

                        // B. Rotating sync outer ring
                        AnimatedBuilder(
                          animation: _rotation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _rotation.value,
                              child: child,
                            );
                          },
                          child: Container(
                            width: 140.w,
                            height: 140.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.blue.withValues(alpha: 0.12),
                                width: 2.w,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 10.h,
                                  left: 60.w,
                                  child: Container(
                                    width: 12.w,
                                    height: 12.h,
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

                        // C. Pulsing heartbeat inner medical logo
                        ScaleTransition(
                          scale: _iconScale,
                          child: CircleAvatar(
                            radius: 50.r,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.health_and_safety,
                              size: 64.r,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 36.h),

                    // D. Sliding and Fading application title
                    FadeTransition(
                      opacity: _textFade,
                      child: SlideTransition(
                        position: _textSlide,
                        child: Column(
                          children: [
                            Text(
                              AppStrings.splashTitle,
                              style: AppTextStyles.headingLarge.copyWith(
                                fontFamily: AppFonts.inter,
                                color: AppColors.primary,
                                fontSize: 36.sp,
                                letterSpacing: 2.w,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              AppStrings.splashSubtitle,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontFamily: AppFonts.inter,
                                color: AppColors.textSecondary,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 4. Bottom Loading Indicator
              Positioned(
                bottom: 60.h,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _bottomLoaderFade,
                  child: Center(
                    child: SizedBox(
                      width: 32.w,
                      height: 32.h,
                      child: CircularProgressIndicator(
                        color: AppColors.primary.withValues(alpha: 0.6),
                        strokeWidth: 2.5.w,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom floating widget to animate background design cross elements
class FloatingMedicalCross extends StatefulWidget {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double size;
  final Color color;
  final Duration duration;

  const FloatingMedicalCross({
    super.key,
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.size,
    required this.color,
    required this.duration,
  });

  @override
  State<FloatingMedicalCross> createState() => _FloatingMedicalCrossState();
}

class _FloatingMedicalCrossState extends State<FloatingMedicalCross>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _yOffset;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);

    _yOffset = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuad),
    );

    _rotation = Tween<double>(begin: -0.12, end: 0.12).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuad),
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
      left: widget.left,
      right: widget.right,
      bottom: widget.bottom,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _yOffset.value),
            child: Transform.rotate(angle: _rotation.value, child: child),
          );
        },
        child: Icon(Icons.add, size: widget.size.r, color: widget.color),
      ),
    );
  }
}

/// Concentric expanding circles radiating behind the center logo (Active cardiac wave effect)
class AnimatedPulseRing extends StatelessWidget {
  final Animation<double> progress;
  final double delay;

  const AnimatedPulseRing({
    super.key,
    required this.progress,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    double value = progress.value - delay;
    if (value < 0) value += 1.0;

    final scale = 1.0 + (value * 1.6);
    final opacity = (1.0 - value).clamp(0.0, 1.0);

    return Opacity(
      opacity: opacity * 0.38,
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: 100.w,
          height: 100.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.6),
              width: 2.w,
            ),
          ),
        ),
      ),
    );
  }
}
