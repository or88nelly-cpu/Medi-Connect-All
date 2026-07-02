import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class OnboardingAnimatedText extends StatefulWidget {
  final String title;
  final String description;

  const OnboardingAnimatedText({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  State<OnboardingAnimatedText> createState() => _OnboardingAnimatedTextState();
}

class _OnboardingAnimatedTextState extends State<OnboardingAnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _descFade;
  late Animation<Offset> _descSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _descFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    _descSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant OnboardingAnimatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.title != oldWidget.title ||
        widget.description != oldWidget.description) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title Animation
          FadeTransition(
            opacity: _titleFade,
            child: SlideTransition(
              position: _titleSlide,
              child: Text(
                widget.title,
                style: AppTextStyles.headingMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 24.sp,
                  color: AppColors.textPrimary(context),
                  letterSpacing: 0.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Description Animation
          FadeTransition(
            opacity: _descFade,
            child: SlideTransition(
              position: _descSlide,
              child: Text(
                widget.description,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary(context),
                  fontSize: 15.sp,
                  height: 1.45,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
