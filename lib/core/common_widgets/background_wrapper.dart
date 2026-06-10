import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import '../utils/constants/app_assets.dart';

class BackgroundWrapper extends StatelessWidget {
  final Widget child;

  const BackgroundWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isWebOrDesktop =
        kIsWeb ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux;

    final bgImage = isWebOrDesktop
        ? AppAssets.commonBgWebPng
        : AppAssets.commonBgMobPng;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF121212) : AppColors.background,
        image: DecorationImage(
          image: AssetImage(bgImage),
          fit: BoxFit.cover,
          colorFilter: isDark
              ? ColorFilter.mode(
                  const Color(0xFF121212).withOpacity(0.95),
                  BlendMode.srcOver,
                )
              : null,
        ),
      ),
      child: child,
    );
  }
}
