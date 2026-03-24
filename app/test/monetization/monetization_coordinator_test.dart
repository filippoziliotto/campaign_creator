import 'dart:async';

import 'package:campaign_creator_flutter/src/monetization/interstitial_ad_service.dart';
import 'package:campaign_creator_flutter/src/monetization/monetization_coordinator.dart';
import 'package:campaign_creator_flutter/src/monetization/monetization_prefs.dart';
import 'package:campaign_creator_flutter/src/monetization/purchase_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late FakeInterstitialAdService fakeAdService;
  late FakePurchaseService fakePurchaseService;
  late MonetizationPrefs prefs;
  late MonetizationCoordinator coordinator;

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    fakeAdService = FakeInterstitialAdService();
    fakePurchaseService = FakePurchaseService();
    prefs = MonetizationPrefs();
    coordinator = MonetizationCoordinator(
      adService: fakeAdService,
      purchaseService: fakePurchaseService,
      prefs: prefs,
    );
  });

  group('recordSuccessfulGeneration', () {
    test('generations 1-4 return belowThreshold', () async {
      final preferences = await SharedPreferences.getInstance();
      for (var i = 1; i <= 4; i++) {
        final outcome = await coordinator.recordSuccessfulGeneration(
          preferences: preferences,
        );
        expect(outcome, InterstitialAdOutcome.belowThreshold,
            reason: 'generation $i should be belowThreshold');
      }
    });

    test('generation 5 returns adShown when ad is ready', () async {
      final preferences = await SharedPreferences.getInstance();
      fakeAdService.shouldBeReady = true;

      for (var i = 1; i <= 4; i++) {
        await coordinator.recordSuccessfulGeneration(
            preferences: preferences);
      }

      final outcome = await coordinator.recordSuccessfulGeneration(
        preferences: preferences,
      );
      expect(outcome, InterstitialAdOutcome.adShown);
      expect(fakeAdService.showCallCount, 1);
    });

    test('generation 5 returns adNotReady when ad is not loaded', () async {
      final preferences = await SharedPreferences.getInstance();
      fakeAdService.shouldBeReady = false;

      for (var i = 1; i <= 4; i++) {
        await coordinator.recordSuccessfulGeneration(
            preferences: preferences);
      }

      final outcome = await coordinator.recordSuccessfulGeneration(
        preferences: preferences,
      );
      expect(outcome, InterstitialAdOutcome.adNotReady);
      expect(fakeAdService.showCallCount, 0);
    });

    test('missed threshold retries on next generation', () async {
      final preferences = await SharedPreferences.getInstance();
      fakeAdService.shouldBeReady = false;

      // Reach threshold (generation 5) but ad not ready
      for (var i = 1; i <= 5; i++) {
        await coordinator.recordSuccessfulGeneration(
            preferences: preferences);
      }
      expect(fakeAdService.showCallCount, 0);

      // Generation 6: ad becomes ready, pending-show triggers it
      fakeAdService.shouldBeReady = true;
      final outcome = await coordinator.recordSuccessfulGeneration(
        preferences: preferences,
      );
      expect(outcome, InterstitialAdOutcome.adShown);
      expect(fakeAdService.showCallCount, 1);
    });

    test('generation 10 returns adShown again', () async {
      final preferences = await SharedPreferences.getInstance();
      fakeAdService.shouldBeReady = true;

      for (var i = 1; i <= 9; i++) {
        await coordinator.recordSuccessfulGeneration(
            preferences: preferences);
      }

      final outcome = await coordinator.recordSuccessfulGeneration(
        preferences: preferences,
      );
      expect(outcome, InterstitialAdOutcome.adShown);
      expect(fakeAdService.showCallCount, 2);
    });

    test('ad-free entitlement forces skipped', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'app.ad_free_purchased': true,
      });
      final preferences = await SharedPreferences.getInstance();

      for (var i = 1; i <= 5; i++) {
        final outcome = await coordinator.recordSuccessfulGeneration(
          preferences: preferences,
        );
        expect(outcome, InterstitialAdOutcome.skipped);
      }
      expect(fakeAdService.showCallCount, 0);
    });

    test('preloads after showing an ad', () async {
      final preferences = await SharedPreferences.getInstance();
      fakeAdService.shouldBeReady = true;

      for (var i = 1; i <= 5; i++) {
        await coordinator.recordSuccessfulGeneration(
            preferences: preferences);
      }

      // preload called for each belowThreshold (4 times) + after show (1 time)
      expect(fakeAdService.preloadCallCount, 5);
    });
  });

  group('handlePurchaseUpdates', () {
    test('purchased status sets ad-free cache', () async {
      final preferences = await SharedPreferences.getInstance();

      final event = await coordinator.handlePurchaseUpdates(
        updates: const [
          NormalizedPurchaseUpdate(
            status: PurchaseUpdateStatus.purchased,
            productId: 'ad_free_upgrade',
            requiresCompletion: true,
            raw: 'raw-purchase-object',
          ),
        ],
        preferences: preferences,
      );

      expect(event, PurchaseEntitlementEvent.granted);
      expect(prefs.isAdFreePurchased(preferences), isTrue);
      expect(fakePurchaseService.completePurchaseCallCount, 1);
    });

    test('restored status sets ad-free cache', () async {
      final preferences = await SharedPreferences.getInstance();

      final event = await coordinator.handlePurchaseUpdates(
        updates: const [
          NormalizedPurchaseUpdate(
            status: PurchaseUpdateStatus.restored,
            productId: 'ad_free_upgrade',
          ),
        ],
        preferences: preferences,
      );

      expect(event, PurchaseEntitlementEvent.restored);
      expect(prefs.isAdFreePurchased(preferences), isTrue);
    });

    test('pending status does not grant entitlement', () async {
      final preferences = await SharedPreferences.getInstance();

      final event = await coordinator.handlePurchaseUpdates(
        updates: const [
          NormalizedPurchaseUpdate(
            status: PurchaseUpdateStatus.pending,
            productId: 'ad_free_upgrade',
          ),
        ],
        preferences: preferences,
      );

      expect(event, PurchaseEntitlementEvent.pending);
      expect(prefs.isAdFreePurchased(preferences), isFalse);
    });

    test('error status does not grant entitlement', () async {
      final preferences = await SharedPreferences.getInstance();

      final event = await coordinator.handlePurchaseUpdates(
        updates: const [
          NormalizedPurchaseUpdate(
            status: PurchaseUpdateStatus.error,
            productId: 'ad_free_upgrade',
            errorMessage: 'Something went wrong',
          ),
        ],
        preferences: preferences,
      );

      expect(event, PurchaseEntitlementEvent.error);
      expect(prefs.isAdFreePurchased(preferences), isFalse);
    });

    test('purchase requiring completion calls completePurchase', () async {
      final preferences = await SharedPreferences.getInstance();
      const rawPurchase = 'raw-purchase-object';

      await coordinator.handlePurchaseUpdates(
        updates: const [
          NormalizedPurchaseUpdate(
            status: PurchaseUpdateStatus.purchased,
            productId: 'ad_free_upgrade',
            requiresCompletion: true,
            raw: rawPurchase,
          ),
        ],
        preferences: preferences,
      );

      expect(fakePurchaseService.completePurchaseCallCount, 1);
      expect(fakePurchaseService.lastCompletedRaw, rawPurchase);
    });
  });

  group('restoreCachedEntitlement', () {
    test('returns true when ad-free is cached', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'app.ad_free_purchased': true,
      });
      final preferences = await SharedPreferences.getInstance();

      final result =
          coordinator.restoreCachedEntitlement(preferences: preferences);
      expect(result, isTrue);
    });

    test('returns false when not purchased', () async {
      final preferences = await SharedPreferences.getInstance();

      final result =
          coordinator.restoreCachedEntitlement(preferences: preferences);
      expect(result, isFalse);
    });
  });
}

class FakeInterstitialAdService implements InterstitialAdService {
  int preloadCallCount = 0;
  int showCallCount = 0;
  bool shouldBeReady = true;

  @override
  Future<void> preload() async => preloadCallCount++;

  @override
  bool get isReady => shouldBeReady;

  @override
  Future<bool> show() async {
    showCallCount++;
    return true;
  }

  @override
  void dispose() {}
}

class FakePurchaseService implements PurchaseService {
  int completePurchaseCallCount = 0;
  Object? lastCompletedRaw;

  @override
  Stream<List<NormalizedPurchaseUpdate>> get purchaseStream =>
      const Stream.empty();

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<PurchaseStartResult> buyAdFree() async =>
      PurchaseStartResult.started;

  @override
  Future<String?> queryAdFreePrice() async => '£1.99';

  @override
  Future<void> restorePurchases() async {}

  @override
  Future<void> completePurchase(Object rawPurchase) async {
    completePurchaseCallCount++;
    lastCompletedRaw = rawPurchase;
  }
}
