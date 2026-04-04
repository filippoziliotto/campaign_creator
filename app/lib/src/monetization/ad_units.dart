import 'dart:io';

import 'package:flutter/foundation.dart';

class MonetizationIds {
  MonetizationIds._();

  static const String adFreeProductId = 'ad_free_upgrade';
  static const String _androidProductionInterstitial =
      'ca-app-pub-9007719672385552/1565750802';
  static const String _iosProductionInterstitial =
      'ca-app-pub-9007719672385552/1526222351';
  static const String _androidProductionRewarded =
      'ca-app-pub-9007719672385552/9497781954';
  static const String _iosProductionRewarded =
      'ca-app-pub-9007719672385552/1959037430';
  static const String _androidProductionAppId =
      'ca-app-pub-9007719672385552~3698660365';
  static const String _iosProductionAppId =
      'ca-app-pub-9007719672385552~4596809069';

  static const String _androidTestInterstitial =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _androidTestRewarded =
      'ca-app-pub-3940256099942544/5224354917';

  /// Retained for tooling/reference. Android registration actually uses
  /// `android/key.properties`, while iOS registration uses `Info.plist`.
  static String get androidAppId => const String.fromEnvironment(
        'ADMOB_APP_ID_ANDROID',
        defaultValue: _androidProductionAppId,
      );

  /// Retained for tooling/reference. Android registration actually uses
  /// `android/key.properties`, while iOS registration uses `Info.plist`.
  static String get iosAppId => const String.fromEnvironment(
        'ADMOB_APP_ID_IOS',
        defaultValue: _iosProductionAppId,
      );

  static String get interstitialAdUnitId {
    final id = _rawInterstitialAdUnitId;
    assert(
      kDebugMode || !_isTestId(id),
      'Release build is using a test ad-unit ID. '
      'Pass --dart-define=ADMOB_INTERSTITIAL_ANDROID=<your-id> '
      'and --dart-define=ADMOB_INTERSTITIAL_IOS=<your-id> for production.',
    );
    return id;
  }

  static String get rewardedAdUnitId {
    final id = _rawRewardedAdUnitId;
    assert(
      kDebugMode || !_isTestId(id),
      'Release build is using a test rewarded ad-unit ID. '
      'Pass --dart-define=ADMOB_REWARDED_ANDROID=<your-id> '
      'and --dart-define=ADMOB_REWARDED_IOS=<your-id> for production.',
    );
    return id;
  }

  static String get _rawInterstitialAdUnitId {
    if (Platform.isAndroid) {
      return const String.fromEnvironment(
        'ADMOB_INTERSTITIAL_ANDROID',
        defaultValue: _androidTestInterstitial,
      );
    }
    if (Platform.isIOS) {
      return const String.fromEnvironment(
        'ADMOB_INTERSTITIAL_IOS',
        defaultValue: _iosProductionInterstitial,
      );
    }
    return '';
  }

  static String get _rawRewardedAdUnitId {
    if (Platform.isAndroid) {
      return const String.fromEnvironment(
        'ADMOB_REWARDED_ANDROID',
        defaultValue: _androidTestRewarded,
      );
    }
    if (Platform.isIOS) {
      return const String.fromEnvironment(
        'ADMOB_REWARDED_IOS',
        defaultValue: _iosProductionRewarded,
      );
    }
    return '';
  }

  static bool get usesTestAds => _isTestId(_rawInterstitialAdUnitId);

  static bool _isTestId(String id) =>
      id.startsWith('ca-app-pub-3940256099942544');
}
