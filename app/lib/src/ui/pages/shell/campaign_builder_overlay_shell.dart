part of 'campaign_builder_page.dart';

class _InfoButton extends StatelessWidget {
  const _InfoButton({
    required this.currentLocale,
    required this.onLocaleChanged,
    required this.currentThemeMode,
    required this.onThemeModeChanged,
    this.onThemeSwitchSound,
    required this.isAdFree,
    required this.isPurchaseBusy,
    this.adFreePrice,
    required this.onGoAdFreeTapped,
    required this.onRestorePurchasesTapped,
    required this.isPrivacyOptionsRequired,
    required this.onPrivacyOptionsTapped,
  });

  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;
  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode>? onThemeModeChanged;
  final VoidCallback? onThemeSwitchSound;
  final bool isAdFree;
  final bool isPurchaseBusy;
  final String? adFreePrice;
  final VoidCallback onGoAdFreeTapped;
  final VoidCallback onRestorePurchasesTapped;
  final Future<bool> Function() isPrivacyOptionsRequired;
  final Future<void> Function() onPrivacyOptionsTapped;

  @override
  Widget build(BuildContext context) {
    return _OverlaySheetButton(
      buttonKey: const ValueKey<String>('info-settings-button'),
      icon: Icons.settings,
      sheetBuilder: (_) => _SettingsSheet(
        currentLocale: currentLocale,
        onLocaleChanged: onLocaleChanged,
        currentThemeMode: currentThemeMode,
        onThemeModeChanged: onThemeModeChanged,
        onThemeSwitchSound: onThemeSwitchSound,
        isAdFree: isAdFree,
        isPurchaseBusy: isPurchaseBusy,
        adFreePrice: adFreePrice,
        onGoAdFreeTapped: onGoAdFreeTapped,
        onRestorePurchasesTapped: onRestorePurchasesTapped,
        isPrivacyOptionsRequired: isPrivacyOptionsRequired,
        onPrivacyOptionsTapped: onPrivacyOptionsTapped,
      ),
    );
  }
}

class _HelpButton extends StatelessWidget {
  const _HelpButton({
    required this.currentThemeMode,
  });

  final ThemeMode currentThemeMode;

  @override
  Widget build(BuildContext context) {
    return _OverlaySheetButton(
      buttonKey: const ValueKey<String>('help-guide-button'),
      icon: Icons.menu_book_rounded,
      sheetBuilder: (_) => _HelpSheet(
        currentThemeMode: currentThemeMode,
      ),
    );
  }
}

class _OverlaySheetButton extends StatefulWidget {
  const _OverlaySheetButton({
    required this.buttonKey,
    required this.icon,
    required this.sheetBuilder,
  });

  final Key buttonKey;
  final IconData icon;
  final WidgetBuilder sheetBuilder;

  @override
  State<_OverlaySheetButton> createState() => _OverlaySheetButtonState();
}

class _OverlaySheetButtonState extends State<_OverlaySheetButton>
    with SingleTickerProviderStateMixin {
  static const Duration _sheetTransitionDuration = Duration(milliseconds: 320);
  late final AnimationController _sheetController;

  @override
  void initState() {
    super.initState();
    _sheetController = AnimationController(
      vsync: this,
      duration: _sheetTransitionDuration,
      reverseDuration: _sheetTransitionDuration,
    );
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton.filled(
      key: widget.buttonKey,
      style: IconButton.styleFrom(
        backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.92),
        foregroundColor: colorScheme.tertiary,
        side: BorderSide(
          color: colorScheme.primary.withValues(alpha: 0.55),
          width: 1.5,
        ),
        minimumSize: const Size(44, 44),
        shape: const CircleBorder(),
      ).copyWith(
        overlayColor: WidgetStatePropertyAll(
          colorScheme.primary.withValues(alpha: 0.14),
        ),
      ),
      icon: Icon(widget.icon, size: 20),
      onPressed: () => _showSheet(context),
    );
  }

  void _showSheet(BuildContext context) {
    final reducedMotion = prefersReducedMotion(context);
    _sheetController.duration =
        reducedMotion ? Duration.zero : _sheetTransitionDuration;
    _sheetController.reverseDuration =
        reducedMotion ? Duration.zero : _sheetTransitionDuration;
    _sheetController.reset();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: false,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: _sheetController,
      builder: widget.sheetBuilder,
    );
  }
}

class _OverlaySheetScaffold extends StatefulWidget {
  const _OverlaySheetScaffold({
    required this.sheetKey,
    required this.dragHandleKey,
    required this.theme,
    required this.title,
    required this.child,
  });

  final Key sheetKey;
  final Key dragHandleKey;
  final ThemeData theme;
  final String title;
  final Widget child;

  @override
  State<_OverlaySheetScaffold> createState() => _OverlaySheetScaffoldState();
}

class _OverlaySheetScaffoldState extends State<_OverlaySheetScaffold>
    with SingleTickerProviderStateMixin {
  static const Duration _contentTransitionDuration =
      Duration(milliseconds: 260);
  static const double _dismissDragThreshold = 22;
  static const double _dismissFlingVelocity = 220;

  late final AnimationController _contentController;
  late final Animation<double> _contentOpacity;
  late final Animation<double> _contentSlide;
  bool _contentAnimationConfigured = false;
  double _dragHandleDistance = 0;

  @override
  void initState() {
    super.initState();
    _contentController = AnimationController(
      vsync: this,
      duration: _contentTransitionDuration,
    );
    _contentOpacity = CurvedAnimation(
      parent: _contentController,
      curve: premiumDecelerationCurve,
    );
    _contentSlide = Tween<double>(begin: 12, end: 0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: premiumDecelerationCurve,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_contentAnimationConfigured) {
      return;
    }

    _contentAnimationConfigured = true;
    if (prefersReducedMotion(context)) {
      _contentController.value = 1;
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      Future<void>.delayed(const Duration(milliseconds: 60), () {
        if (mounted) {
          _contentController.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _dismissSheet() {
    if (!mounted) {
      return;
    }
    Navigator.of(context).maybePop();
  }

  void _handleDragStart(DragStartDetails details) {
    _dragHandleDistance = 0;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _dragHandleDistance += details.delta.dy;
    if (_dragHandleDistance >= _dismissDragThreshold) {
      _dragHandleDistance = 0;
      _dismissSheet();
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    _dragHandleDistance = 0;
    if (velocity >= _dismissFlingVelocity) {
      _dismissSheet();
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = widget.theme.fantasy;
    final textTheme = widget.theme.textTheme;

    return Theme(
      data: widget.theme,
      child: Container(
        key: widget.sheetKey,
        decoration: BoxDecoration(
          color: palette.card,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(
            top: BorderSide(color: palette.outline, width: 1.5),
            left: BorderSide(color: palette.outline, width: 1.5),
            right: BorderSide(color: palette.outline, width: 1.5),
          ),
        ),
        child: SafeArea(
          top: false,
          child: FadeTransition(
            opacity: _contentOpacity,
            child: AnimatedBuilder(
              animation: _contentSlide,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, _contentSlide.value),
                child: child,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        key: widget.dragHandleKey,
                        behavior: HitTestBehavior.opaque,
                        onVerticalDragStart: _handleDragStart,
                        onVerticalDragUpdate: _handleDragUpdate,
                        onVerticalDragEnd: _handleDragEnd,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 12, 24, 6),
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: palette.outline,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
                      child: Text(
                        widget.title,
                        style: textTheme.titleLarge?.copyWith(
                          color: palette.foreground,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    widget.child,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsSheet extends StatefulWidget {
  const _SettingsSheet({
    required this.currentLocale,
    required this.onLocaleChanged,
    required this.currentThemeMode,
    required this.onThemeModeChanged,
    this.onThemeSwitchSound,
    required this.isAdFree,
    required this.isPurchaseBusy,
    this.adFreePrice,
    required this.onGoAdFreeTapped,
    required this.onRestorePurchasesTapped,
    required this.isPrivacyOptionsRequired,
    required this.onPrivacyOptionsTapped,
  });

  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;
  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode>? onThemeModeChanged;
  final VoidCallback? onThemeSwitchSound;
  final bool isAdFree;
  final bool isPurchaseBusy;
  final String? adFreePrice;
  final VoidCallback onGoAdFreeTapped;
  final VoidCallback onRestorePurchasesTapped;
  final Future<bool> Function() isPrivacyOptionsRequired;
  final Future<void> Function() onPrivacyOptionsTapped;

  @override
  State<_SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<_SettingsSheet> {
  late ThemeMode _selectedThemeMode;

  @override
  void initState() {
    super.initState();
    _selectedThemeMode = widget.currentThemeMode;
  }

  void _handleThemeSelection(ThemeMode themeMode) {
    if (themeMode == _selectedThemeMode) {
      return;
    }

    widget.onThemeSwitchSound?.call();
    setState(() {
      _selectedThemeMode = themeMode;
    });
    widget.onThemeModeChanged?.call(themeMode);
  }

  void _handleLanguageSelection(String languageCode) {
    if (languageCode == widget.currentLocale.languageCode) {
      return;
    }

    final navigator = Navigator.of(context);
    widget.onLocaleChanged(Locale(languageCode));
    if (mounted) {
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final sheetTheme = _selectedThemeMode == ThemeMode.light
        ? buildFantasyLightTheme()
        : buildFantasyTheme();
    final palette = sheetTheme.fantasy;
    final textTheme = sheetTheme.textTheme;
    final bodyStyle =
        textTheme.bodySmall?.copyWith(color: palette.foregroundMuted);

    return _OverlaySheetScaffold(
      sheetKey: const ValueKey<String>('settings-sheet'),
      dragHandleKey: const ValueKey<String>('settings-sheet-drag-handle'),
      theme: sheetTheme,
      title: context.l10n.settingsTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
            child: Text(
              context.l10n.settingsLanguageLabel,
              style: textTheme.labelSmall?.copyWith(
                color: palette.foregroundMuted,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            child: SegmentedButton<String>(
              key: const ValueKey<String>('settings-language-control'),
              showSelectedIcon: false,
              segments: <ButtonSegment<String>>[
                ButtonSegment<String>(
                  value: 'en',
                  label: _LanguageSegmentLabel(
                    key: const ValueKey<String>('settings-language-segment-en'),
                    languageCode: 'en',
                    shortLabel: context.l10n.languageEnglishShort,
                    outlineColor: palette.outline.withValues(alpha: 0.72),
                  ),
                ),
                ButtonSegment<String>(
                  value: 'it',
                  label: _LanguageSegmentLabel(
                    key: const ValueKey<String>('settings-language-segment-it'),
                    languageCode: 'it',
                    shortLabel: context.l10n.languageItalianShort,
                    outlineColor: palette.outline.withValues(alpha: 0.72),
                  ),
                ),
                ButtonSegment<String>(
                  value: 'es',
                  label: _LanguageSegmentLabel(
                    key: const ValueKey<String>('settings-language-segment-es'),
                    languageCode: 'es',
                    shortLabel: context.l10n.languageSpanishShort,
                    outlineColor: palette.outline.withValues(alpha: 0.72),
                  ),
                ),
                ButtonSegment<String>(
                  value: 'fr',
                  label: _LanguageSegmentLabel(
                    key: const ValueKey<String>('settings-language-segment-fr'),
                    languageCode: 'fr',
                    shortLabel: context.l10n.languageFrenchShort,
                    outlineColor: palette.outline.withValues(alpha: 0.72),
                  ),
                ),
                ButtonSegment<String>(
                  value: 'de',
                  label: _LanguageSegmentLabel(
                    key: const ValueKey<String>('settings-language-segment-de'),
                    languageCode: 'de',
                    shortLabel: context.l10n.languageGermanShort,
                    outlineColor: palette.outline.withValues(alpha: 0.72),
                  ),
                ),
                ButtonSegment<String>(
                  value: 'pt',
                  label: _LanguageSegmentLabel(
                    key: const ValueKey<String>('settings-language-segment-pt'),
                    languageCode: 'pt',
                    shortLabel: context.l10n.languagePortugueseShort,
                    outlineColor: palette.outline.withValues(alpha: 0.72),
                  ),
                ),
              ],
              selected: <String>{widget.currentLocale.languageCode},
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                ),
                backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                  (states) {
                    if (states.contains(WidgetState.selected)) {
                      return palette.cardSoft;
                    }
                    return palette.card.withValues(alpha: 0.82);
                  },
                ),
                foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                  (states) {
                    if (states.contains(WidgetState.selected)) {
                      return palette.accent;
                    }
                    return palette.foreground;
                  },
                ),
                side: WidgetStatePropertyAll<BorderSide>(
                  BorderSide(
                    color: palette.outline.withValues(alpha: 0.7),
                  ),
                ),
              ),
              onSelectionChanged: (selection) =>
                  _handleLanguageSelection(selection.first),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
            child: Text(
              context.l10n.settingsThemeLabel,
              style: textTheme.labelSmall?.copyWith(
                color: palette.foregroundMuted,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            child: SegmentedButton<ThemeMode>(
              key: const ValueKey<String>('settings-theme-control'),
              showSelectedIcon: false,
              segments: const <ButtonSegment<ThemeMode>>[
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.dark,
                  icon: Icon(Icons.nightlight_round, size: 18),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.light,
                  icon: Icon(Icons.wb_sunny_rounded, size: 18),
                ),
              ],
              selected: <ThemeMode>{_selectedThemeMode},
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                  (states) {
                    if (states.contains(WidgetState.selected)) {
                      return palette.cardSoft;
                    }
                    return palette.card.withValues(alpha: 0.82);
                  },
                ),
                foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                  (states) {
                    if (states.contains(WidgetState.selected)) {
                      return palette.accent;
                    }
                    return palette.foreground;
                  },
                ),
                side: WidgetStatePropertyAll<BorderSide>(
                  BorderSide(
                    color: palette.outline.withValues(alpha: 0.7),
                  ),
                ),
              ),
              onSelectionChanged: (selection) =>
                  _handleThemeSelection(selection.first),
            ),
          ),
          Divider(
            color: palette.outline.withValues(alpha: 0.4),
            indent: 24,
            endIndent: 24,
          ),
          ListTile(
            key: const ValueKey<String>('settings-review-row'),
            leading: Icon(Icons.star_outline, color: palette.accent),
            title: Text(
              context.l10n.settingsLeaveReview,
              style: textTheme.bodyLarge?.copyWith(color: palette.foreground),
            ),
            onTap: () => _launchReview(context),
          ),
          ListTile(
            key: const ValueKey<String>('settings-share-row'),
            leading: Icon(Icons.share, color: palette.accent),
            title: Text(
              context.l10n.settingsShareApp,
              style: textTheme.bodyLarge?.copyWith(color: palette.foreground),
            ),
            onTap: () => _shareApp(context),
          ),
          if (!widget.isAdFree) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
              child: Text(
                context.l10n.settingsGoAdFree,
                style: textTheme.labelSmall?.copyWith(
                  color: palette.foregroundMuted,
                ),
              ),
            ),
            ListTile(
              key: const ValueKey<String>('settings-go-ad-free-row'),
              leading: FaIcon(
                FontAwesomeIcons.crown,
                color: palette.accent,
                size: 22,
              ),
              title: Text(
                context.l10n.settingsGoAdFreePrice,
                style: textTheme.bodyLarge?.copyWith(color: palette.foreground),
              ),
              subtitle: Text(
                widget.adFreePrice != null
                    ? context.l10n
                        .settingsGoAdFreeSubtitleWithAmount(widget.adFreePrice!)
                    : context.l10n.settingsGoAdFreeSubtitle,
                style: textTheme.labelSmall?.copyWith(
                  color: palette.accent,
                ),
              ),
              enabled: !widget.isPurchaseBusy,
              onTap: () {
                Navigator.of(context).pop();
                widget.onGoAdFreeTapped();
              },
            ),
            ListTile(
              key: const ValueKey<String>('settings-restore-purchases-row'),
              leading: Icon(Icons.restore_rounded, color: palette.accent),
              title: Text(
                context.l10n.settingsRestorePurchases,
                style: textTheme.bodyLarge?.copyWith(color: palette.foreground),
              ),
              enabled: !widget.isPurchaseBusy,
              onTap: () {
                Navigator.of(context).pop();
                widget.onRestorePurchasesTapped();
              },
            ),
            FutureBuilder<bool>(
              future: widget.isPrivacyOptionsRequired(),
              builder: (context, snapshot) {
                if (!(snapshot.data ?? false)) {
                  return const SizedBox.shrink();
                }

                return ListTile(
                  key: const ValueKey<String>('settings-privacy-options-row'),
                  leading: Icon(
                    Icons.privacy_tip_outlined,
                    color: palette.accent,
                  ),
                  title: Text(
                    context.l10n.settingsPrivacyOptions,
                    style: textTheme.bodyLarge?.copyWith(
                      color: palette.foreground,
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await widget.onPrivacyOptionsTapped();
                  },
                );
              },
            ),
          ] else ...[
            FutureBuilder<bool>(
              future: widget.isPrivacyOptionsRequired(),
              builder: (context, snapshot) {
                if (!(snapshot.data ?? false)) {
                  return const SizedBox.shrink();
                }

                return ListTile(
                  key: const ValueKey<String>('settings-privacy-options-row'),
                  leading: Icon(
                    Icons.privacy_tip_outlined,
                    color: palette.accent,
                  ),
                  title: Text(
                    context.l10n.settingsPrivacyOptions,
                    style: textTheme.bodyLarge?.copyWith(
                      color: palette.foreground,
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await widget.onPrivacyOptionsTapped();
                  },
                );
              },
            ),
            ListTile(
              key: const ValueKey<String>('settings-ad-free-active-row'),
              leading: Icon(Icons.check_circle_rounded, color: palette.accent),
              title: Text(
                context.l10n.settingsAdFreeActive,
                style: textTheme.bodyLarge?.copyWith(color: palette.foreground),
              ),
            ),
          ],
          Divider(
            color: palette.outline.withValues(alpha: 0.4),
            indent: 24,
            endIndent: 24,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
            child: Text(
              context.l10n.settingsInfoLabel,
              style: textTheme.labelSmall?.copyWith(
                color: palette.foregroundMuted,
              ),
            ),
          ),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final version = snapshot.data?.version ?? '—';
              return Padding(
                padding: const EdgeInsets.fromLTRB(24, 6, 24, 0),
                child: Text(
                  key: const ValueKey<String>('settings-version-text'),
                  '${context.l10n.settingsVersion} $version',
                  style: bodyStyle,
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
            child: Text(context.l10n.infoDialogLine1, style: bodyStyle),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
            child: Text(context.l10n.infoDialogLine2, style: bodyStyle),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
            child: Text(context.l10n.infoDialogLine3, style: bodyStyle),
          ),
        ],
      ),
    );
  }

  Future<void> _launchReview(BuildContext context) async {
    final url = defaultTargetPlatform == TargetPlatform.iOS
        ? AppConfig.appStoreUrl
        : AppConfig.playStoreUrl;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Rect? _shareOriginForContext(BuildContext context) {
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) {
      return null;
    }
    final origin = renderObject.localToGlobal(Offset.zero);
    return origin & renderObject.size;
  }

  Future<void> _shareApp(BuildContext context) async {
    final url = defaultTargetPlatform == TargetPlatform.iOS
        ? AppConfig.appStoreUrl
        : AppConfig.playStoreUrl;
    await SharePlus.instance.share(
      ShareParams(
        text: context.l10n.settingsShareText + url,
        sharePositionOrigin: _shareOriginForContext(context),
      ),
    );
  }
}

class _HelpSheet extends StatelessWidget {
  const _HelpSheet({
    required this.currentThemeMode,
  });

  final ThemeMode currentThemeMode;

  @override
  Widget build(BuildContext context) {
    final sheetTheme = currentThemeMode == ThemeMode.light
        ? buildFantasyLightTheme()
        : buildFantasyTheme();
    final palette = sheetTheme.fantasy;
    final textTheme = sheetTheme.textTheme;

    return _OverlaySheetScaffold(
      sheetKey: const ValueKey<String>('help-sheet'),
      dragHandleKey: const ValueKey<String>('help-sheet-drag-handle'),
      theme: sheetTheme,
      title: context.l10n.helpTitle,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HelpSectionTitle(
              title: context.l10n.helpCampaignTypesTitle,
              textTheme: textTheme,
              palette: palette,
            ),
            _HelpCampaignTypeBlock(
              title: context.l10n.helpCampaignTypeOneShotTitle,
              description: context.l10n.helpCampaignTypeOneShotBody,
              textTheme: textTheme,
              palette: palette,
            ),
            _HelpCampaignTypeBlock(
              title: context.l10n.helpCampaignTypeMiniCampaignTitle,
              description: context.l10n.helpCampaignTypeMiniCampaignBody,
              textTheme: textTheme,
              palette: palette,
            ),
            _HelpCampaignTypeBlock(
              title: context.l10n.helpCampaignTypeLongCampaignTitle,
              description: context.l10n.helpCampaignTypeLongCampaignBody,
              textTheme: textTheme,
              palette: palette,
            ),
            _HelpCampaignTypeBlock(
              title: context.l10n.helpCampaignTypeDungeonTitle,
              description: context.l10n.helpCampaignTypeDungeonBody,
              textTheme: textTheme,
              palette: palette,
            ),
            const SizedBox(height: 16),
            _HelpSectionTitle(
              title: context.l10n.helpTipsTitle,
              textTheme: textTheme,
              palette: palette,
            ),
            _HelpTipRow(
              text: context.l10n.helpTipWorld,
              textTheme: textTheme,
              palette: palette,
            ),
            _HelpTipRow(
              text: context.l10n.helpTipTheme,
              textTheme: textTheme,
              palette: palette,
            ),
            _HelpTipRow(
              text: context.l10n.helpTipTwist,
              textTheme: textTheme,
              palette: palette,
            ),
            _HelpTipRow(
              text: context.l10n.helpTipContrast,
              textTheme: textTheme,
              palette: palette,
            ),
            _HelpTipRow(
              text: context.l10n.helpTipPreset,
              textTheme: textTheme,
              palette: palette,
            ),
            _HelpTipRow(
              text: context.l10n.helpTipCustom,
              textTheme: textTheme,
              palette: palette,
            ),
            _HelpTipRow(
              text: context.l10n.helpTipParty,
              textTheme: textTheme,
              palette: palette,
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpSectionTitle extends StatelessWidget {
  const _HelpSectionTitle({
    required this.title,
    required this.textTheme,
    required this.palette,
  });

  final String title;
  final TextTheme textTheme;
  final FantasyThemeColors palette;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: textTheme.titleMedium?.copyWith(
          color: palette.foreground,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _HelpCampaignTypeBlock extends StatelessWidget {
  const _HelpCampaignTypeBlock({
    required this.title,
    required this.description,
    required this.textTheme,
    required this.palette,
  });

  final String title;
  final String description;
  final TextTheme textTheme;
  final FantasyThemeColors palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.cardSoft.withValues(alpha: 0.52),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.outline.withValues(alpha: 0.55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.bodyLarge?.copyWith(
              color: palette.foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: textTheme.bodySmall?.copyWith(
              color: palette.foregroundMuted,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpTipRow extends StatelessWidget {
  const _HelpTipRow({
    required this.text,
    required this.textTheme,
    required this.palette,
  });

  final String text;
  final TextTheme textTheme;
  final FantasyThemeColors palette;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 14,
              color: palette.accent,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: textTheme.bodySmall?.copyWith(
                color: palette.foregroundMuted,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageSegmentLabel extends StatelessWidget {
  const _LanguageSegmentLabel({
    super.key,
    required this.languageCode,
    required this.shortLabel,
    required this.outlineColor,
  });

  final String languageCode;
  final String shortLabel;
  final Color outlineColor;

  @override
  Widget build(BuildContext context) {
    final labelStyle = DefaultTextStyle.of(context).style.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          letterSpacing: 0.2,
        );

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LanguageMark(
            key: ValueKey<String>('settings-language-mark-$languageCode'),
            languageCode: languageCode,
            outlineColor: outlineColor,
          ),
          const SizedBox(width: 4),
          Text(
            shortLabel,
            style: labelStyle,
            maxLines: 1,
            softWrap: false,
          ),
        ],
      ),
    );
  }
}

class _LanguageMark extends StatelessWidget {
  const _LanguageMark({
    super.key,
    required this.languageCode,
    required this.outlineColor,
  });

  final String languageCode;
  final Color outlineColor;

  @override
  Widget build(BuildContext context) {
    final countryCode = switch (languageCode) {
      'en' => 'US',
      'it' => 'IT',
      'es' => 'ES',
      'fr' => 'FR',
      'de' => 'DE',
      'pt' => 'PT',
      _ => 'US',
    };

    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: outlineColor, width: 0.1),
          borderRadius: BorderRadius.circular(3),
        ),
        child: CountryFlag.fromCountryCode(
          countryCode,
          theme: const ImageTheme(
            width: 16,
            height: 12,
          ),
        ),
      ),
    );
  }
}
