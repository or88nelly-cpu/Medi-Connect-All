import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';

class QrScannerOverlay extends StatefulWidget {
  final List<UserModel> demoPatients;
  final Function(UserModel) onQrScanned;

  const QrScannerOverlay({
    super.key,
    required this.demoPatients,
    required this.onQrScanned,
  });

  @override
  State<QrScannerOverlay> createState() => _QrScannerOverlayState();
}

class _QrScannerOverlayState extends State<QrScannerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _laserController;
  late Animation<double> _laserAnimation;

  @override
  void initState() {
    super.initState();
    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _laserAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _laserController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _laserController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final overlayColor = Colors.black.withValues(alpha: 0.7);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 1. Dark overlay background with transparent cutout
          ColorFiltered(
            colorFilter: ColorFilter.mode(overlayColor, BlendMode.srcOut),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),
                Center(
                  child: Container(
                    width: 250.r,
                    height: 250.r,
                    decoration: BoxDecoration(
                      color: Colors.red, // Arbitrary color for cutout
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. Scan box outline & animation
          Center(
            child: SizedBox(
              width: 250.r,
              height: 250.r,
              child: Stack(
                children: [
                  // Corner borders
                  Positioned(
                    top: 0,
                    left: 0,
                    child: _buildCorner(isTop: true, isLeft: true),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: _buildCorner(isTop: true, isLeft: false),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: _buildCorner(isTop: false, isLeft: true),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: _buildCorner(isTop: false, isLeft: false),
                  ),

                  // Animated laser line
                  AnimatedBuilder(
                    animation: _laserAnimation,
                    builder: (context, child) {
                      return Positioned(
                        top: 250.r * _laserAnimation.value,
                        left: 10.w,
                        right: 10.w,
                        child: Container(
                          height: 3.h,
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.success.withValues(alpha: 0.8),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // 3. User instructions and controls
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top bar
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Scan Patient QR/UHID",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Center text
                Text(
                  "Align the QR code within the frame",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12.sp,
                  ),
                ),

                // Bottom Demo selector
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.terminalDarkCard
                        : AppColors.terminalLightCard,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Simulate QR Scan (Select Demo Patient)",
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12.h),
                      if (widget.demoPatients.isEmpty)
                        Text(
                          "No demo patients available.",
                          style: TextStyle(
                            color: isDark ? Colors.white54 : Colors.black54,
                            fontSize: 11.sp,
                          ),
                          textAlign: TextAlign.center,
                        )
                      else
                        SizedBox(
                          height: 70.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.demoPatients.length,
                            itemBuilder: (context, index) {
                              final p = widget.demoPatients[index];
                              return GestureDetector(
                                onTap: () {
                                  widget.onQrScanned(p);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 140.w,
                                  margin: EdgeInsets.only(right: 10.w),
                                  padding: EdgeInsets.all(8.r),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        p.fullName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11.sp,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        p.id,
                                        style: TextStyle(
                                          fontSize: 9.sp,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner({required bool isTop, required bool isLeft}) {
    const double size = 20;
    const double thickness = 4;
    final color = AppColors.success;

    return SizedBox(
      width: size.w,
      height: size.h,
      child: Stack(
        children: [
          Positioned(
            top: isTop ? 0 : null,
            bottom: isTop ? null : 0,
            left: isLeft ? 0 : null,
            right: isLeft ? null : 0,
            child: Container(width: size.w, height: thickness.h, color: color),
          ),
          Positioned(
            top: isTop ? 0 : null,
            bottom: isTop ? null : 0,
            left: isLeft ? 0 : null,
            right: isLeft ? null : 0,
            child: Container(width: thickness.w, height: size.h, color: color),
          ),
        ],
      ),
    );
  }
}
