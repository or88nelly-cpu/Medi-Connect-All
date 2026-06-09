/// A premium background wrapper that loads the platform-specific common background images
/// (common_bg_mob.png for mobile, common_bg_web.png for web/desktop).
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(bgImage), fit: BoxFit.cover),
      ),
      child: child,
    );
  }
}
