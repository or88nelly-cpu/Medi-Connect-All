import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_assets.dart';

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

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgImage = isWebOrDesktop
        ? (isDark ? AppAssets.commonBgWebPngDark : AppAssets.commonBgWebPng)
        : (isDark ? AppAssets.commonBgMobPngDark : AppAssets.commonBgMobPng);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background(context),
        image: DecorationImage(image: AssetImage(bgImage), fit: BoxFit.cover),
      ),
      child: child,
    );
  }
}
