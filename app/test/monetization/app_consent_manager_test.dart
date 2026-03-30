import 'package:campaign_creator_flutter/src/monetization/app_consent_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  group('DefaultAppConsentManager', () {
    test('gathers consent and initializes ads when ads can be requested',
        () async {
      final platform = _FakeConsentPlatform()
        ..canRequestAdsValue = true
        ..privacyStatus = PrivacyOptionsRequirementStatus.required;
      final manager = DefaultAppConsentManager(platform: platform);

      await manager.gatherConsent();
      await manager.initializeAdsIfAllowed();

      expect(platform.requestConsentInfoUpdateCallCount, 1);
      expect(platform.loadAndShowConsentFormIfRequiredCallCount, 1);
      expect(platform.initializeMobileAdsCallCount, 1);
      expect(await manager.canRequestAds(), isTrue);
      expect(await manager.isPrivacyOptionsRequired(), isTrue);
    });

    test('does not initialize ads when ads cannot be requested', () async {
      final platform = _FakeConsentPlatform()..canRequestAdsValue = false;
      final manager = DefaultAppConsentManager(platform: platform);

      await manager.gatherConsent();
      await manager.initializeAdsIfAllowed();

      expect(platform.initializeMobileAdsCallCount, 0);
    });

    test('shows privacy options form through the platform', () async {
      final platform = _FakeConsentPlatform()
        ..privacyStatus = PrivacyOptionsRequirementStatus.required;
      final manager = DefaultAppConsentManager(platform: platform);

      await manager.showPrivacyOptionsForm();

      expect(platform.showPrivacyOptionsFormCallCount, 1);
    });
  });
}

class _FakeConsentPlatform implements ConsentPlatform {
  int requestConsentInfoUpdateCallCount = 0;
  int loadAndShowConsentFormIfRequiredCallCount = 0;
  int initializeMobileAdsCallCount = 0;
  int showPrivacyOptionsFormCallCount = 0;
  bool canRequestAdsValue = false;
  PrivacyOptionsRequirementStatus privacyStatus =
      PrivacyOptionsRequirementStatus.notRequired;

  @override
  Future<bool> canRequestAds() async => canRequestAdsValue;

  @override
  Future<PrivacyOptionsRequirementStatus> getPrivacyOptionsRequirementStatus()
      async => privacyStatus;

  @override
  Future<InitializationStatus> initializeMobileAds() async {
    initializeMobileAdsCallCount += 1;
    return InitializationStatus(<String, AdapterStatus>{});
  }

  @override
  Future<FormError?> loadAndShowConsentFormIfRequired() async {
    loadAndShowConsentFormIfRequiredCallCount += 1;
    return null;
  }

  @override
  Future<FormError?> requestConsentInfoUpdate(
    ConsentRequestParameters params,
  ) async {
    requestConsentInfoUpdateCallCount += 1;
    return null;
  }

  @override
  Future<FormError?> showPrivacyOptionsForm() async {
    showPrivacyOptionsFormCallCount += 1;
    return null;
  }
}
