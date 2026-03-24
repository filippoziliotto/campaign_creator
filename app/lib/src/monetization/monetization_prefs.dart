import 'package:shared_preferences/shared_preferences.dart';

class MonetizationPrefs {
  MonetizationPrefs({
    this.adGenerationCountKey = 'app.ad_generation_count',
    this.adFreePurchasedKey = 'app.ad_free_purchased',
  });

  final String adGenerationCountKey;
  final String adFreePurchasedKey;

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
}
