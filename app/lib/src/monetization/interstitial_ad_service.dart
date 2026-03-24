import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_units.dart';

abstract class InterstitialAdService {
  Future<void> preload();
  bool get isReady;
  Future<bool> show();
  void dispose();
}

class DefaultInterstitialAdService implements InterstitialAdService {
  InterstitialAd? _interstitialAd;
  bool _isReady = false;
  bool _isLoading = false;
  bool _disposed = false;

  @override
  bool get isReady => _isReady && !_disposed;

  @override
  Future<void> preload() async {
    if (_disposed || _isReady || _isLoading) return;

    _isLoading = true;

    final adUnitId = MonetizationIds.interstitialAdUnitId;
    if (adUnitId.isEmpty) return;

    final completer = Completer<void>();

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isReady = true;
          _isLoading = false;
          if (!completer.isCompleted) completer.complete();
        },
        onAdFailedToLoad: (error) {
          _isReady = false;
          _isLoading = false;
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );

    await completer.future;
  }

  @override
  Future<bool> show() async {
    final ad = _interstitialAd;
    if (ad == null || _disposed) return false;

    final completer = Completer<bool>();

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _isReady = false;
        if (!completer.isCompleted) completer.complete(true);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        _isReady = false;
        if (!completer.isCompleted) completer.complete(false);
      },
    );

    await ad.show();
    return completer.future;
  }

  @override
  void dispose() {
    _disposed = true;
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isReady = false;
  }
}
