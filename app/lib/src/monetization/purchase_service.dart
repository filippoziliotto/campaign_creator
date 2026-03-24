import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

import 'ad_units.dart';

enum PurchaseUpdateStatus {
  pending,
  purchased,
  restored,
  cancelled,
  error,
}

class NormalizedPurchaseUpdate {
  const NormalizedPurchaseUpdate({
    required this.status,
    this.productId,
    this.errorMessage,
    this.requiresCompletion = false,
    this.raw,
  });

  final PurchaseUpdateStatus status;
  final String? productId;
  final String? errorMessage;
  final bool requiresCompletion;
  final Object? raw;
}

abstract class PurchaseService {
  Stream<List<NormalizedPurchaseUpdate>> get purchaseStream;
  Future<bool> isAvailable();
  Future<PurchaseStartResult> buyAdFree();
  Future<String?> queryAdFreePrice();
  Future<void> restorePurchases();
  Future<void> completePurchase(Object rawPurchase);
}

enum PurchaseStartResult {
  started,
  unavailable,
  productNotFound,
  error,
}

class DefaultPurchaseService implements PurchaseService {
  DefaultPurchaseService({InAppPurchase? iap})
      : _iap = iap ?? InAppPurchase.instance;

  final InAppPurchase _iap;

  @override
  Stream<List<NormalizedPurchaseUpdate>> get purchaseStream {
    return _iap.purchaseStream.map((purchases) {
      return purchases.map(_normalize).toList();
    });
  }

  @override
  Future<bool> isAvailable() => _iap.isAvailable();

  @override
  Future<PurchaseStartResult> buyAdFree() async {
    try {
      final available = await _iap.isAvailable();
      if (!available) return PurchaseStartResult.unavailable;

      final response = await _iap.queryProductDetails(
        {MonetizationIds.adFreeProductId},
      );
      if (response.productDetails.isEmpty) {
        return PurchaseStartResult.productNotFound;
      }

      final product = response.productDetails.first;
      final started = await _iap.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: product),
      );
      return started
          ? PurchaseStartResult.started
          : PurchaseStartResult.error;
    } catch (_) {
      return PurchaseStartResult.error;
    }
  }

  @override
  Future<String?> queryAdFreePrice() async {
    try {
      final available = await _iap.isAvailable();
      if (!available) return null;

      final response = await _iap.queryProductDetails(
        {MonetizationIds.adFreeProductId},
      );
      if (response.productDetails.isEmpty) return null;
      return response.productDetails.first.price;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> restorePurchases() async {
    try {
      await _iap.restorePurchases();
    } catch (_) {
      // Swallow: caller relies on purchase stream events for state.
    }
  }

  @override
  Future<void> completePurchase(Object rawPurchase) async {
    if (rawPurchase is PurchaseDetails) {
      await _iap.completePurchase(rawPurchase);
    }
  }

  NormalizedPurchaseUpdate _normalize(PurchaseDetails details) {
    final PurchaseUpdateStatus status;
    switch (details.status) {
      case PurchaseStatus.pending:
        status = PurchaseUpdateStatus.pending;
      case PurchaseStatus.purchased:
        status = PurchaseUpdateStatus.purchased;
      case PurchaseStatus.restored:
        status = PurchaseUpdateStatus.restored;
      case PurchaseStatus.canceled:
        status = PurchaseUpdateStatus.cancelled;
      case PurchaseStatus.error:
        status = PurchaseUpdateStatus.error;
    }

    return NormalizedPurchaseUpdate(
      status: status,
      productId: details.productID,
      errorMessage: details.error?.message,
      requiresCompletion: details.pendingCompletePurchase,
      raw: details,
    );
  }
}
