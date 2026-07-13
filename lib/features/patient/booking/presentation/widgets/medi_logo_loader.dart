import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_assets.dart';

class MediLogoLoader extends StatefulWidget {
  final double? size;

  const MediLogoLoader({super.key, this.size});

  @override
  State<MediLogoLoader> createState() => _MediLogoLoaderState();
}

class _MediLogoLoaderState extends State<MediLogoLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultSize = widget.size ?? 64.r;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _animation,
            child: Image.asset(
              AppAssets.logoIconPng,
              width: defaultSize,
              height: defaultSize,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading MediConnect...',
            style: TextStyle(
              color: const Color(0xFF0A3BB0),
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
