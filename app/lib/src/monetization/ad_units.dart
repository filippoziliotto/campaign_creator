import 'dart:io';

import 'package:flutter/foundation.dart';

class MonetizationIds {
  MonetizationIds._();

  static const String adFreeProductId = 'ad_free_upgrade';

  static const String _androidTestInterstitial =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _iosTestInterstitial =
      'ca-app-pub-3940256099942544/4411468910';

  static const String _androidTestAppId =
      'ca-app-pub-3940256099942544~3347511713';
  static const String _iosTestAppId =
      'ca-app-pub-3940256099942544~1458002511';

  static String get androidAppId => const String.fromEnvironment(
        'ADMOB_APP_ID_ANDROID',
        defaultValue: _androidTestAppId,
      );

  static String get iosAppId => const String.fromEnvironment(
        'ADMOB_APP_ID_IOS',
        defaultValue: _iosTestAppId,
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
        defaultValue: _iosTestInterstitial,
      );
    }
    return '';
  }

  static bool get usesTestAds => _isTestId(_rawInterstitialAdUnitId);

  static bool _isTestId(String id) =>
      id.startsWith('ca-app-pub-3940256099942544');
}
