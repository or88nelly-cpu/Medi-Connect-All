import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class AnimatedGradientButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color startColor;
  final Color endColor;
  final double height;
  final IconData icon;

  const AnimatedGradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.startColor,
    required this.endColor,
    this.height = 50,
    this.icon = Icons.arrow_forward_rounded,
  });

  @override
  State<AnimatedGradientButton> createState() => _AnimatedGradientButtonState();
}

class _AnimatedGradientButtonState extends State<AnimatedGradientButton>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.scale(scale: _pressed ? .97 : 1, child: child);
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onPressed();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            height: widget.height.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.lerp(
                    widget.startColor,
                    Colors.white,
                    _controller.value * .08,
                  )!,
                  Color.lerp(
                    widget.endColor,
                    Colors.white,
                    _controller.value * .04,
                  )!,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.startColor.withValues(
                    alpha: 0.20 + (_controller.value * 0.12),
                  ),
                  blurRadius: 18,
                  spreadRadius: 1,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                children: [
                  const Spacer(),

                  Text(
                    widget.text,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontSize: (widget.height / 50) * 14.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .3,
                    ),
                  ),

                  const Spacer(),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: (widget.height / 50) * 36.r,
                    height: (widget.height / 50) * 36.r,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.startColor,
                      size: (widget.height / 50) * 20.r,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
