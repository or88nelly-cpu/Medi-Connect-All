import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'dart:math' hide log;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';

/// Centralized service to manage Google Mobile Ads loading, display, and cleanup.
/// Implements lazy loading, exponential backoff retries, and platform-specific test IDs.
@lazySingleton
class AdService {
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  // Google Standard Test Ad Unit IDs
  static const String _androidBannerId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _iosBannerId = 'ca-app-pub-3940256099942544/2934735716';

  static const String _androidInterstitialId = 'ca-app-pub-3940256099942544/1033173712';
  static const String _iosInterstitialId = 'ca-app-pub-3940256099942544/4411468910';

  static const String _androidRewardedId = 'ca-app-pub-3940256099942544/5224354917';
  static const String _iosRewardedId = 'ca-app-pub-3940256099942544/1712485313';

  /// Returns target banner ad unit ID based on device platform.
  String get bannerAdUnitId {
    if (kDebugMode) {
      return defaultTargetPlatform == TargetPlatform.android ? _androidBannerId : _iosBannerId;
    }
    return defaultTargetPlatform == TargetPlatform.android ? _androidBannerId : _iosBannerId;
  }

  /// Returns target interstitial ad unit ID based on device platform.
  String get interstitialAdUnitId {
    if (kDebugMode) {
      return defaultTargetPlatform == TargetPlatform.android ? _androidInterstitialId : _iosInterstitialId;
    }
    return defaultTargetPlatform == TargetPlatform.android ? _androidInterstitialId : _iosInterstitialId;
  }

  /// Returns target rewarded ad unit ID based on device platform.
  String get rewardedAdUnitId {
    if (kDebugMode) {
      return defaultTargetPlatform == TargetPlatform.android ? _androidRewardedId : _iosRewardedId;
    }
    return defaultTargetPlatform == TargetPlatform.android ? _androidRewardedId : _iosRewardedId;
  }

  /// Initializes the Google Mobile Ads SDK.
  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      log('Google Mobile Ads SDK Initialized successfully.');
    } catch (e) {
      log('Failed to initialize Google Mobile Ads: $e');
    }
  }

  /// Loads a BannerAd. Supports exponential backoff retries on failure.
  void loadBannerAd({
    required Function(BannerAd ad) onAdLoaded,
    required Function(LoadAdError error) onAdFailedToLoad,
    int retryCount = 0,
  }) {
    late BannerAd bannerAd;
    bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          log('BannerAd loaded: ${ad.adUnitId}');
          onAdLoaded(ad as BannerAd);
        },
        onAdFailedToLoad: (ad, error) {
          log('BannerAd failed to load: $error');
          ad.dispose();
          if (retryCount < 3) {
            final nextRetrySeconds = pow(2, retryCount + 1).toInt();
            log('Retrying BannerAd load in $nextRetrySeconds seconds...');
            Future.delayed(Duration(seconds: nextRetrySeconds), () {
              loadBannerAd(
                onAdLoaded: onAdLoaded,
                onAdFailedToLoad: onAdFailedToLoad,
                retryCount: retryCount + 1,
              );
            });
          } else {
            onAdFailedToLoad(error);
          }
        },
      ),
    );
    bannerAd.load();
  }

  /// Loads an InterstitialAd. Supports exponential backoff retries on failure.
  void loadInterstitialAd({
    required Function(InterstitialAd ad) onAdLoaded,
    required Function(LoadAdError error) onAdFailedToLoad,
    int retryCount = 0,
  }) {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          log('InterstitialAd loaded: ${ad.adUnitId}');
          onAdLoaded(ad);
        },
        onAdFailedToLoad: (error) {
          log('InterstitialAd failed to load: $error');
          if (retryCount < 3) {
            final nextRetrySeconds = pow(2, retryCount + 1).toInt();
            log('Retrying InterstitialAd load in $nextRetrySeconds seconds...');
            Future.delayed(Duration(seconds: nextRetrySeconds), () {
              loadInterstitialAd(
                onAdLoaded: onAdLoaded,
                onAdFailedToLoad: onAdFailedToLoad,
                retryCount: retryCount + 1,
              );
            });
          } else {
            onAdFailedToLoad(error);
          }
        },
      ),
    );
  }

  /// Loads a RewardedAd. Supports exponential backoff retries on failure.
  void loadRewardedAd({
    required Function(RewardedAd ad) onAdLoaded,
    required Function(LoadAdError error) onAdFailedToLoad,
    int retryCount = 0,
  }) {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          log('RewardedAd loaded: ${ad.adUnitId}');
          onAdLoaded(ad);
        },
        onAdFailedToLoad: (error) {
          log('RewardedAd failed to load: $error');
          if (retryCount < 3) {
            final nextRetrySeconds = pow(2, retryCount + 1).toInt();
            log('Retrying RewardedAd load in $nextRetrySeconds seconds...');
            Future.delayed(Duration(seconds: nextRetrySeconds), () {
              loadRewardedAd(
                onAdLoaded: onAdLoaded,
                onAdFailedToLoad: onAdFailedToLoad,
                retryCount: retryCount + 1,
              );
            });
          } else {
            onAdFailedToLoad(error);
          }
        },
      ),
    );
  }
}
