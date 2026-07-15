import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:medi_connect/core/services/ad_service.dart';

/// Enterprise-grade ad banner that loads and displays real Google Mobile Ads.
/// Ensures proper disposal and non-blocking placeholder rendering.
class GoogleAdBanner extends StatefulWidget {
  const GoogleAdBanner({super.key});

  @override
  State<GoogleAdBanner> createState() => _GoogleAdBannerState();
}

class _GoogleAdBannerState extends State<GoogleAdBanner> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    GetIt.instance<AdService>().loadBannerAd(
      onAdLoaded: (ad) {
        if (mounted) {
          setState(() {
            _bannerAd = ad;
            _isAdLoaded = true;
          });
        }
      },
      onAdFailedToLoad: (error) {
        log('Ad banner load failed: $error');
      },
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd != null && _isAdLoaded) {
      return Container(
        alignment: Alignment.center,
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: AdWidget(ad: _bannerAd!),
      );
    }
    return const SizedBox.shrink();
  }
}
