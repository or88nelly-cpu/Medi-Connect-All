import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class GoogleAdBanner extends StatefulWidget {
  const GoogleAdBanner({super.key});

  @override
  State<GoogleAdBanner> createState() => _GoogleAdBannerState();
}

class _GoogleAdBannerState extends State<GoogleAdBanner> {
  int _currentAdIndex = 0;
  Timer? _rotationTimer;
  bool _isVisible = true;

  final List<Map<String, dynamic>> _ads = [
    {
      'title': 'Medi-Connect Premium',
      'description':
          'Unlimited 24/7 consultations with top cardiologists and neurologists for just ₹499/mo.',
      'tagline': 'Join Now',
      'gradient': [const Color(0xFF6366F1), const Color(0xFF4F46E5)],
      'badgeColor': const Color(0xFFEEF2FF),
      'badgeTextColor': const Color(0xFF4F46E5),
      'icon': Icons.stars_rounded,
    },
    {
      'title': 'Medi-Lab Smart Checkup',
      'description':
          'Complete health profiles including Lipid, Thyroid & CBC with home sample collection. Flat 30% OFF.',
      'tagline': 'Book Today',
      'gradient': [const Color(0xFF0D9488), const Color(0xFF0F766E)],
      'badgeColor': const Color(0xFFF0FDFA),
      'badgeTextColor': const Color(0xFF0F766E),
      'icon': Icons.biotech_rounded,
    },
    {
      'title': '2-Hour Pharmacy Delivery',
      'description':
          'Get essential medicines delivered to your doorstep. Use code HEALTH30 for flat 30% off.',
      'tagline': 'Order Now',
      'gradient': [const Color(0xFFEA580C), const Color(0xFFC2410C)],
      'badgeColor': const Color(0xFFFFF7ED),
      'badgeTextColor': const Color(0xFFC2410C),
      'icon': Icons.local_shipping_rounded,
    },
    {
      'title': 'Free Diet Consultation',
      'description':
          'Consult with our certified clinical nutritionists for personalized diet and workout plans.',
      'tagline': 'Claim Offer',
      'gradient': [const Color(0xFF16A34A), const Color(0xFF15803D)],
      'badgeColor': const Color(0xFFF0FDF4),
      'badgeTextColor': const Color(0xFF15803D),
      'icon': Icons.restaurant_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    _rotationTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (mounted) {
        setState(() {
          _currentAdIndex = (_currentAdIndex + 1) % _ads.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _rotationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    final ad = _ads[_currentAdIndex];

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          colors: ad['gradient'] as List<Color>,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (ad['gradient'] as List<Color>).last.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Ad Badge
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline, color: Colors.white70, size: 10.sp),
                  SizedBox(width: 3.w),
                  Text(
                    'Sponsored',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Close button
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isVisible = false;
                });
              },
              child: Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 12.sp,
                ),
              ),
            ),
          ),

          // Content Layout
          Padding(
            padding: EdgeInsets.only(top: 14.h),
            child: Row(
              children: [
                // Icon
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    ad['icon'] as IconData,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                // Text Area
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        ad['title'] as String,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        ad['description'] as String,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 10.sp,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                // Action Button Tagline
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: ad['badgeColor'] as Color,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    ad['tagline'] as String,
                    style: TextStyle(
                      color: ad['badgeTextColor'] as Color,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
