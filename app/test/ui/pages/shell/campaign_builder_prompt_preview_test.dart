import 'package:campaign_creator_flutter/l10n/app_localizations.dart';
import 'package:campaign_creator_flutter/src/ui/pages/shell/campaign_builder_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/fake_campaign_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'campaign_builder.saved_prompt': _longPrompt,
      'campaign_builder.saved_campaign_type': 'One-Shot',
      'campaign_builder.saved_setting': 'Forgotten Realms',
    });
  });

  testWidgets('preview sheet shows the full prompt and stays scrollable', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(minimalOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: _noopLocale,
        ),
      ),
    );

    await _pumpUi(tester);
    await _openSavedParchment(
      tester,
      resumeLabel: 'Riprendi la forgia',
      parchmentLabel: 'Pergamena',
    );

    await tester.tap(find.byKey(const ValueKey('parchment-action-preview')));
    await _pumpUi(tester);

    final previewSheet = find.byKey(const ValueKey('parchment-preview-sheet'));

    expect(find.text('Anteprima prompt'), findsOneWidget);
    expect(
      find.descendant(of: previewSheet, matching: find.text('Copia prompt')),
      findsNothing,
    );
    expect(
      find.descendant(
        of: previewSheet,
        matching: find.text(
          'Controlla il prompt completo prima di copiarlo o incollarlo.',
        ),
      ),
      findsNothing,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is SelectableText &&
            (widget.data ?? '').contains('LINE 60'),
      ),
      findsOneWidget,
    );

    final scrollable = find.byKey(const ValueKey('parchment-preview-scroll'));
    await tester.drag(scrollable, const Offset(0, -300), warnIfMissed: false);
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('it'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        final data = MediaQuery.of(context).copyWith(disableAnimations: true);
        return MediaQuery(data: data, child: child!);
      },
      home: child,
    );
  }
}

const String _longPrompt = '''
LINE 1
LINE 2
LINE 3
LINE 4
LINE 5
LINE 6
LINE 7
LINE 8
LINE 9
LINE 10
LINE 11
LINE 12
LINE 13
LINE 14
LINE 15
LINE 16
LINE 17
LINE 18
LINE 19
LINE 20
LINE 21
LINE 22
LINE 23
LINE 24
LINE 25
LINE 26
LINE 27
LINE 28
LINE 29
LINE 30
LINE 31
LINE 32
LINE 33
LINE 34
LINE 35
LINE 36
LINE 37
LINE 38
LINE 39
LINE 40
LINE 41
LINE 42
LINE 43
LINE 44
LINE 45
LINE 46
LINE 47
LINE 48
LINE 49
LINE 50
LINE 51
LINE 52
LINE 53
LINE 54
LINE 55
LINE 56
LINE 57
LINE 58
LINE 59
LINE 60
LINE 61
LINE 62
LINE 63
LINE 64
LINE 65
LINE 66
LINE 67
LINE 68
LINE 69
LINE 70
LINE 71
LINE 72
LINE 73
LINE 74
LINE 75
LINE 76
LINE 77
LINE 78
LINE 79
LINE 80
''';

void _noopLocale(Locale _) {}

Future<void> _openSavedParchment(
  WidgetTester tester, {
  required String resumeLabel,
  required String parchmentLabel,
}) async {
  final resumeButton = find.text(resumeLabel);
  await tester.ensureVisible(resumeButton);
  await tester.tap(resumeButton);
  await _pumpUi(tester);

  final parchmentStage = find.text(parchmentLabel);
  await tester.ensureVisible(parchmentStage);
  await tester.tap(parchmentStage);
  await _pumpUi(tester);
}

Future<void> _pumpUi(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 800));
}
