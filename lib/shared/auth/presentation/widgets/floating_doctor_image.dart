import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_assets.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

class FloatingDoctorImage extends StatefulWidget {
  final double height;

  const FloatingDoctorImage({
    super.key,
    required this.height,
  });

  @override
  State<FloatingDoctorImage> createState() => _FloatingDoctorImageState();
}

class _FloatingDoctorImageState extends State<FloatingDoctorImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keep width proportionate to height (approx 1:1.4 aspect ratio)
    final width = widget.height * 0.7;

    return SizedBox(
      height: widget.height,
      width: width,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Static beautiful doctor girl image (stable body alignment)
          Positioned.fill(
            child: Image.asset(
              AppAssets.ladyImagePng,
              fit: BoxFit.contain,
            ),
          ),
          
          // Concentric signal/pulse animations aligned precisely on top of the phone screen in her hands
          Positioned(
            top: widget.height * 0.49,
            left: width * 0.42,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: List.generate(3, (index) {
                    final progress = (_controller.value + index / 3) % 1.0;
                    final size = 12.r + (progress * 56.r);
                    final opacity = (1.0 - progress).clamp(0.0, 1.0);
                    
                    return Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: opacity * 0.45),
                          width: 1.5.r,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: opacity * 0.15),
                            blurRadius: 8.r,
                            spreadRadius: 1.r,
                          )
                        ],
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
