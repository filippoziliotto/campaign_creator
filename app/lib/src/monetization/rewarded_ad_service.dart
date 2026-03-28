import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_units.dart';

abstract class RewardedAdService {
  Future<void> preload();
  bool get isSupported;
  bool get isReady;
  Future<bool> show();
  void dispose();
}

class DefaultRewardedAdService implements RewardedAdService {
  RewardedAd? _rewardedAd;
  bool _isReady = false;
  bool _isLoading = false;
  bool _disposed = false;

  @override
  bool get isSupported => MonetizationIds.rewardedAdUnitId.isNotEmpty;

  @override
  bool get isReady => _isReady && !_disposed;

  @override
  Future<void> preload() async {
    if (_disposed || _isReady || _isLoading) return;

    final adUnitId = MonetizationIds.rewardedAdUnitId;
    if (adUnitId.isEmpty) return;

    _isLoading = true;
    final completer = Completer<void>();

    RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isReady = true;
          _isLoading = false;
          if (!completer.isCompleted) completer.complete();
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
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
    final ad = _rewardedAd;
    if (ad == null || _disposed) return false;

    final completer = Completer<bool>();
    var rewardEarned = false;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        _isReady = false;
        if (!completer.isCompleted) completer.complete(rewardEarned);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        _isReady = false;
        if (!completer.isCompleted) completer.complete(false);
      },
    );

    await ad.show(
      onUserEarnedReward: (_, __) {
        rewardEarned = true;
      },
    );
    return completer.future;
  }

  @override
  void dispose() {
    _disposed = true;
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isReady = false;
  }
}
