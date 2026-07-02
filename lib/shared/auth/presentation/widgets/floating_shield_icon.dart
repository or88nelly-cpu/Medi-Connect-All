import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

class FloatingShieldIcon extends StatefulWidget {
  final double top;
  final double left;

  const FloatingShieldIcon({
    super.key,
    required this.top,
    required this.left,
  });

  @override
  State<FloatingShieldIcon> createState() => _FloatingShieldIconState();
}

class _FloatingShieldIconState extends State<FloatingShieldIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _yOffset;
  late Animation<double> _glowScale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _yOffset = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuad),
    );

    _glowScale = Tween<double>(begin: 0.95, end: 1.05).animate(
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
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _yOffset.value),
            child: Transform.scale(
              scale: _glowScale.value,
              child: child,
            ),
          );
        },
        child: Container(
          width: 54.r,
          height: 54.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.12),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.35),
              width: 1.5.r,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.2),
                blurRadius: 15.r,
                spreadRadius: 2.r,
              ),
            ],
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.shield,
                  color: AppColors.primary.withValues(alpha: 0.85),
                  size: 28.r,
                ),
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 16.r,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
