import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

class GlowingProgressBar extends StatefulWidget {
  final double width;
  final Duration duration;

  const GlowingProgressBar({
    super.key,
    this.width = 240,
    this.duration = const Duration(milliseconds: 2600),
  });

  @override
  State<GlowingProgressBar> createState() => _GlowingProgressBarState();
}

class _GlowingProgressBarState extends State<GlowingProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            return Container(
              width: widget.width.w,
              height: 4.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.r),
                color: Colors.white.withValues(alpha: 0.08),
              ),
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: _progressAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.r),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primaryLight,
                            Colors.white,
                          ],
                          stops: const [0.0, 0.75, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryLight.withValues(alpha: 0.6),
                            blurRadius: 8.r,
                            spreadRadius: 1.r,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
