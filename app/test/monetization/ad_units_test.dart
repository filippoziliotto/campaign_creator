import 'package:campaign_creator_flutter/src/monetization/ad_units.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ios monetization defaults mirror project production ids', () {
    expect(
      MonetizationIds.iosAppId,
      'ca-app-pub-9007719672385552~4596809069',
    );
  });

  test('android monetization app id getter remains available', () {
    expect(
      MonetizationIds.androidAppId,
      'ca-app-pub-9007719672385552~3698660365',
    );
  });
}
