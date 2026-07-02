/// Splash page shown on app launch.
/// Displays a premium heartbeat pulse, concentric cardiac pulse waves, rotating sync animation,
/// and floating interactive medical crosses. Verifies auth state and routes.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/constants/app_enum.dart';
import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/constants/app_assets.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';

// Separate premium splash widgets
import 'package:medi_connect/shared/auth/presentation/widgets/heartbeat_pulse_line.dart';
import 'package:medi_connect/shared/auth/presentation/widgets/glowing_progress_bar.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _bgController;
  late AnimationController _entranceController;

  // Animation definitions
  late Animation<double> _bgScale;
  late Animation<double> _logoFade;
  late Animation<double> _logoScale;
  late Animation<double> _overlaysFade;
  late Animation<double> _bottomFade;

  @override
  void initState() {
    super.initState();

    // 1. Ken Burns background zoom
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );
    _bgScale = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _bgController, curve: Curves.easeOutCubic),
    );
    _bgController.forward();

    // 2. Entrance animations for logo and overlays
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeIn),
      ),
    );

    _logoScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );

    _overlaysFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.75, curve: Curves.easeIn),
      ),
    );

    _bottomFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.55, 1.0, curve: Curves.easeIn),
      ),
    );

    _entranceController.forward();

    // Trigger auth session verification.
    context.read<AuthBloc>().add(AuthCheckRequested());
  }

  @override
  void dispose() {
    _bgController.dispose();
    _entranceController.dispose();
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
          final role = state.user.role.value;
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

              // 2. Responsive UI Elements
              if (isWebOrDesktop)
                _buildWebLayout()
              else ...[
                // Mobile layout elements directly inside full-screen Stack
                // A. Centered Logo at the top region
                Positioned(
                  top: 110.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: FadeTransition(
                      opacity: _logoFade,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: Image.asset(
                          AppAssets.logoIconPng,
                          width: 280.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),

                // B. Bottom Section: Heartbeat wave, Slogan, and Loading Progress
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: FadeTransition(
                    opacity: _bottomFade,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Heartbeat Pulse Wave
                        const HeartbeatPulseLine(height: 55),
                        SizedBox(height: 12.h),

                        // Platform Tagline Text
                        Text(
                          "One Platform. Every Connection.",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.95),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 4.h),

                        // Platform Bold Tagline (Gold)
                        Text(
                          "Better Healthcare.",
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.secondary,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 36.h),

                        // Bottom linear glow progress indicator
                        const GlowingProgressBar(width: 200),
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // WEB/DESKTOP LAYOUT (Left Side Centered Column)
  // ─────────────────────────────────────────────────────────
  Widget _buildWebLayout() {
    return Positioned(
      left: 100.w,
      top: 0,
      bottom: 0,
      width: 420.w,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // A. Logo image
              FadeTransition(
                opacity: _logoFade,
                child: ScaleTransition(
                  scale: _logoScale,
                  child: Image.asset(
                    AppAssets.logoIconPng,
                    width: 180.r,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 48.h),

              // B. Heartbeat Pulse Wave
              FadeTransition(
                opacity: _bottomFade,
                child: const HeartbeatPulseLine(height: 60),
              ),
              SizedBox(height: 24.h),

              // C. Taglines
              FadeTransition(
                opacity: _bottomFade,
                child: Column(
                  children: [
                    Text(
                      "One Platform. Every Connection.",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.95),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      "Better Healthcare.",
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.secondary,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 48.h),

              // D. Glowing progress bar
              FadeTransition(
                opacity: _bottomFade,
                child: const GlowingProgressBar(width: 220),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
