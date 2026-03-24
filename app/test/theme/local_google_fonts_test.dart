import 'package:campaign_creator_flutter/src/theme/fantasy_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('fantasy theme fonts resolve from bundled assets without runtime fetch', () async {
    final previousSetting = GoogleFonts.config.allowRuntimeFetching;
    GoogleFonts.config.allowRuntimeFetching = false;

    addTearDown(() {
      GoogleFonts.config.allowRuntimeFetching = previousSetting;
    });

    buildFantasyTheme();

    await expectLater(GoogleFonts.pendingFonts(), completes);
  });
}
