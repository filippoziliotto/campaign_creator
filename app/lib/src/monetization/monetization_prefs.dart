import 'package:shared_preferences/shared_preferences.dart';

class MonetizationPrefs {
  MonetizationPrefs({
    this.adGenerationCountKey = 'app.ad_generation_count',
    this.adFreePurchasedKey = 'app.ad_free_purchased',
    this.premiumTemporaryUnlockTimestampKey =
        'app.premium_temporary_unlock_timestamp',
  });

  final String adGenerationCountKey;
  final String adFreePurchasedKey;
  final String premiumTemporaryUnlockTimestampKey;

  Future<int> incrementAdGenerationCount(SharedPreferences preferences) async {
    final next = (preferences.getInt(adGenerationCountKey) ?? 0) + 1;
    await preferences.setInt(adGenerationCountKey, next);
    return next;
  }

  bool isAdFreePurchased(SharedPreferences preferences) =>
      preferences.getBool(adFreePurchasedKey) ?? false;

  Future<void> setAdFreePurchased(
    SharedPreferences preferences,
    bool value,
  ) async {
    await preferences.setBool(adFreePurchasedKey, value);
  }

  int? getTemporaryUnlockTimestamp(SharedPreferences preferences) =>
      preferences.getInt(premiumTemporaryUnlockTimestampKey);

  Future<void> setTemporaryUnlockTimestamp(
    SharedPreferences preferences,
    int epochMs,
  ) async {
    await preferences.setInt(premiumTemporaryUnlockTimestampKey, epochMs);
  }

  Future<void> clearTemporaryUnlockTimestamp(
    SharedPreferences preferences,
  ) async {
    await preferences.remove(premiumTemporaryUnlockTimestampKey);
  }
}
