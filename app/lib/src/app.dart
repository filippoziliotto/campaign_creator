import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:campaign_creator_flutter/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n_extension.dart';
import 'theme/fantasy_theme.dart';
import 'ui/pages/shell/campaign_builder_page.dart';

typedef CampaignCreatorHomeBuilder = Widget Function(
  Locale locale,
  ValueChanged<Locale> onLocaleChanged,
  ThemeMode themeMode,
  ValueChanged<ThemeMode> onThemeModeChanged,
);

class CampaignCreatorApp extends StatefulWidget {
  const CampaignCreatorApp({
    super.key,
    this.homeBuilder,
  });

  final CampaignCreatorHomeBuilder? homeBuilder;

  @override
  State<CampaignCreatorApp> createState() => _CampaignCreatorAppState();
}

class _CampaignCreatorAppState extends State<CampaignCreatorApp> {
  static const String _localePreferenceKey = 'app.locale_code';
  static const String _themePreferenceKey = 'app.theme_mode';
  static const Locale _fallbackLocale = Locale('en');
  static const List<Locale> _supportedLocales = <Locale>[
    Locale('en'),
    Locale('it'),
    Locale('es'),
    Locale('fr'),
    Locale('de'),
  ];

  late Locale _locale;
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  void initState() {
    super.initState();
    _locale = _resolveDeviceLocale();
    _restoreSavedLocale();
    _restoreSavedThemeMode();
  }

  Future<void> _restoreSavedLocale() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final savedCode = preferences.getString(_localePreferenceKey);
      if (savedCode == null) {
        return;
      }

      final restoredLocale = _resolveSupportedLocale(savedCode);
      if (!mounted || restoredLocale == _locale) {
        return;
      }
      setState(() {
        _locale = restoredLocale;
      });
    } on MissingPluginException {
      return;
    } on PlatformException {
      return;
    }
  }

  Future<void> _restoreSavedThemeMode() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final savedTheme = preferences.getString(_themePreferenceKey);
      if (savedTheme == null) {
        return;
      }

      final restoredThemeMode = _resolveThemeMode(savedTheme);
      if (!mounted || restoredThemeMode == _themeMode) {
        return;
      }

      setState(() {
        _themeMode = restoredThemeMode;
      });
    } on MissingPluginException {
      return;
    } on PlatformException {
      return;
    }
  }

  Locale _resolveDeviceLocale() {
    for (final locale in WidgetsBinding.instance.platformDispatcher.locales) {
      final supported = _supportedLocales.where(
        (candidate) => candidate.languageCode == locale.languageCode,
      );
      if (supported.isNotEmpty) {
        return supported.first;
      }
    }
    return _fallbackLocale;
  }

  Locale _resolveSupportedLocale(String languageCode) {
    return _supportedLocales.firstWhere(
      (locale) => locale.languageCode == languageCode,
      orElse: () => _fallbackLocale,
    );
  }

  ThemeMode _resolveThemeMode(String? themeModeName) {
    switch (themeModeName) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
      default:
        return ThemeMode.dark;
    }
  }

  Future<void> _setLocale(Locale locale) async {
    final resolvedLocale = _resolveSupportedLocale(locale.languageCode);
    if (resolvedLocale == _locale) {
      return;
    }

    setState(() {
      _locale = resolvedLocale;
    });

    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(
        _localePreferenceKey,
        resolvedLocale.languageCode,
      );
    } on MissingPluginException {
      return;
    } on PlatformException {
      return;
    }
  }

  Future<void> _setThemeMode(ThemeMode themeMode) async {
    if (themeMode == _themeMode) {
      return;
    }

    setState(() {
      _themeMode = themeMode;
    });

    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(_themePreferenceKey, themeMode.name);
    } on MissingPluginException {
      return;
    } on PlatformException {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildFantasyLightTheme(),
      darkTheme: buildFantasyTheme(),
      themeMode: _themeMode,
      locale: _locale,
      onGenerateTitle: (context) => context.l10n.appTitle,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: _supportedLocales,
      home: widget.homeBuilder?.call(
            _locale,
            _setLocale,
            _themeMode,
            _setThemeMode,
          ) ??
          CampaignBuilderPage(
            currentLocale: _locale,
            onLocaleChanged: _setLocale,
            currentThemeMode: _themeMode,
            onThemeModeChanged: _setThemeMode,
          ),
    );
  }
}
