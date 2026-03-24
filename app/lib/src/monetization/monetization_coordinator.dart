import 'package:shared_preferences/shared_preferences.dart';

import 'ad_units.dart';
import 'interstitial_ad_service.dart';
import 'monetization_prefs.dart';
import 'purchase_service.dart';

enum InterstitialAdOutcome {
  skipped,
  belowThreshold,
  adShown,
  adNotReady,
  adFailed,
}

enum PurchaseEntitlementEvent {
  none,
  pending,
  granted,
  restored,
  cancelled,
  error,
}

class MonetizationCoordinator {
  MonetizationCoordinator({
    required InterstitialAdService adService,
    required PurchaseService purchaseService,
    required MonetizationPrefs prefs,
    this.generationsPerAd = 5,
  })  : _adService = adService,
        _purchaseService = purchaseService,
        _prefs = prefs;

  final InterstitialAdService _adService;
  final PurchaseService _purchaseService;
  final MonetizationPrefs _prefs;
  final int generationsPerAd;
  bool _pendingAdShow = false;

  Future<InterstitialAdOutcome> recordSuccessfulGeneration({
    required SharedPreferences preferences,
  }) async {
    if (_prefs.isAdFreePurchased(preferences)) {
      _pendingAdShow = false;
      return InterstitialAdOutcome.skipped;
    }

    final count = await _prefs.incrementAdGenerationCount(preferences);
    final isThreshold = count % generationsPerAd == 0;

    if (!isThreshold && !_pendingAdShow) {
      await _adService.preload();
      return InterstitialAdOutcome.belowThreshold;
    }

    if (!_adService.isReady) {
      _pendingAdShow = true;
      await _adService.preload();
      return InterstitialAdOutcome.adNotReady;
    }

    _pendingAdShow = false;
    final shown = await _adService.show();
    await _adService.preload();
    return shown
        ? InterstitialAdOutcome.adShown
        : InterstitialAdOutcome.adFailed;
  }

  bool restoreCachedEntitlement({
    required SharedPreferences preferences,
  }) {
    return _prefs.isAdFreePurchased(preferences);
  }

  Future<PurchaseStartResult> startAdFreePurchase() =>
      _purchaseService.buyAdFree();

  Future<void> restorePurchases() => _purchaseService.restorePurchases();

  Future<PurchaseEntitlementEvent> handlePurchaseUpdates({
    required List<NormalizedPurchaseUpdate> updates,
    required SharedPreferences preferences,
  }) async {
    PurchaseEntitlementEvent lastEvent = PurchaseEntitlementEvent.none;

    for (final update in updates) {
      if (update.productId != MonetizationIds.adFreeProductId) continue;

      switch (update.status) {
        case PurchaseUpdateStatus.purchased:
          await _prefs.setAdFreePurchased(preferences, true);
          if (update.requiresCompletion && update.raw != null) {
            await _purchaseService.completePurchase(update.raw!);
          }
          lastEvent = PurchaseEntitlementEvent.granted;

        case PurchaseUpdateStatus.restored:
          await _prefs.setAdFreePurchased(preferences, true);
          if (update.requiresCompletion && update.raw != null) {
            await _purchaseService.completePurchase(update.raw!);
          }
          lastEvent = PurchaseEntitlementEvent.restored;

        case PurchaseUpdateStatus.pending:
          lastEvent = PurchaseEntitlementEvent.pending;

        case PurchaseUpdateStatus.cancelled:
          lastEvent = PurchaseEntitlementEvent.cancelled;

        case PurchaseUpdateStatus.error:
          lastEvent = PurchaseEntitlementEvent.error;
      }
    }

    return lastEvent;
  }
}
