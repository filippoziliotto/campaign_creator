import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

final AppConsentManager appConsentManager = DefaultAppConsentManager();

abstract class AppConsentManager {
  Future<void> gatherConsent();
  Future<bool> canRequestAds();
  Future<void> initializeAdsIfAllowed();
  Future<bool> isPrivacyOptionsRequired();
  Future<void> showPrivacyOptionsForm();
}

abstract class ConsentPlatform {
  Future<FormError?> requestConsentInfoUpdate(
    ConsentRequestParameters params,
  );
  Future<FormError?> loadAndShowConsentFormIfRequired();
  Future<bool> canRequestAds();
  Future<PrivacyOptionsRequirementStatus> getPrivacyOptionsRequirementStatus();
  Future<FormError?> showPrivacyOptionsForm();
  Future<InitializationStatus> initializeMobileAds();
}

class DefaultAppConsentManager implements AppConsentManager {
  DefaultAppConsentManager({ConsentPlatform? platform})
      : _platform = platform ?? GoogleMobileAdsConsentPlatform();

  final ConsentPlatform _platform;
  Future<void>? _gatherConsentFuture;
  Future<void>? _initializeAdsFuture;
  bool _mobileAdsInitialized = false;

  @override
  Future<void> gatherConsent() async {
    _gatherConsentFuture ??= _gatherConsentInternal();
    await _gatherConsentFuture;
  }

  Future<void> _gatherConsentInternal() async {
    final error = await _platform.requestConsentInfoUpdate(
      ConsentRequestParameters(),
    );
    if (error != null) {
      debugPrint(
        'Consent info update error: ${error.errorCode} ${error.message}',
      );
      return;
    }

    final formError = await _platform.loadAndShowConsentFormIfRequired();
    if (formError != null) {
      debugPrint(
        'Consent form error: ${formError.errorCode} ${formError.message}',
      );
    }
  }

  @override
  Future<bool> canRequestAds() async {
    try {
      return await _platform.canRequestAds();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> initializeAdsIfAllowed() async {
    if (_mobileAdsInitialized) {
      return;
    }
    if (!await canRequestAds()) {
      return;
    }

    _initializeAdsFuture ??= _initializeAdsIfAllowedInternal();
    await _initializeAdsFuture;
  }

  Future<void> _initializeAdsIfAllowedInternal() async {
    try {
      await _platform.initializeMobileAds();
      _mobileAdsInitialized = true;
    } catch (error) {
      debugPrint('Mobile Ads init error: $error');
      return;
    } finally {
      if (!_mobileAdsInitialized) {
        _initializeAdsFuture = null;
      }
    }
  }

  @override
  Future<bool> isPrivacyOptionsRequired() async {
    try {
      return await _platform.getPrivacyOptionsRequirementStatus() ==
          PrivacyOptionsRequirementStatus.required;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> showPrivacyOptionsForm() async {
    try {
      final error = await _platform.showPrivacyOptionsForm();
      if (error != null) {
        debugPrint(
          'Privacy options error: ${error.errorCode} ${error.message}',
        );
      }

      await initializeAdsIfAllowed();
    } catch (error) {
      debugPrint('Show privacy options error: $error');
      return;
    }
  }
}

class GoogleMobileAdsConsentPlatform implements ConsentPlatform {
  @override
  Future<FormError?> requestConsentInfoUpdate(
    ConsentRequestParameters params,
  ) {
    final completer = Completer<FormError?>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () => completer.complete(null),
      (error) => completer.complete(error),
    );
    return completer.future;
  }

  @override
  Future<FormError?> loadAndShowConsentFormIfRequired() {
    final completer = Completer<FormError?>();
    ConsentForm.loadAndShowConsentFormIfRequired(
      (error) => completer.complete(error),
    );
    return completer.future;
  }

  @override
  Future<bool> canRequestAds() => ConsentInformation.instance.canRequestAds();

  @override
  Future<PrivacyOptionsRequirementStatus> getPrivacyOptionsRequirementStatus() {
    return ConsentInformation.instance.getPrivacyOptionsRequirementStatus();
  }

  @override
  Future<FormError?> showPrivacyOptionsForm() {
    final completer = Completer<FormError?>();
    ConsentForm.showPrivacyOptionsForm(
      (error) => completer.complete(error),
    );
    return completer.future;
  }

  @override
  Future<InitializationStatus> initializeMobileAds() {
    return MobileAds.instance.initialize();
  }
}
