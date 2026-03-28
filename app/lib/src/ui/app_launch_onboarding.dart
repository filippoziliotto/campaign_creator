import 'package:flutter/material.dart';

import '../theme/fantasy_theme.dart';
import 'pages/design/campaign_builder_motion.dart';

class AppLaunchOnboardingGate extends StatefulWidget {
  const AppLaunchOnboardingGate({
    super.key,
    required this.child,
    this.showOnLaunch = true,
  });

  final Widget child;
  final bool showOnLaunch;

  @override
  State<AppLaunchOnboardingGate> createState() =>
      _AppLaunchOnboardingGateState();
}

class _AppLaunchOnboardingGateState extends State<AppLaunchOnboardingGate> {
  static const List<_OnboardingSlideSpec> _slides = <_OnboardingSlideSpec>[
    _OnboardingSlideSpec(
      title: 'Choose Campaign',
      body: 'Pick the kind of adventure you want to build.',
      primaryLabel: 'Next',
      secondaryLabel: 'Skip',
      primaryAction: _OnboardingAction.next,
      secondaryAction: _OnboardingAction.dismiss,
      visualKind: _OnboardingVisualKind.campaignType,
      titleFontSizeOffset: -7,
    ),
    _OnboardingSlideSpec(
      title: 'Define the world and key details',
      body:
          'Set the setting, themes, tone, style, party, and twist. The more clearly you define these signals, the more focused and usable the final prompt becomes.',
      primaryLabel: 'Next',
      secondaryLabel: 'Back',
      primaryAction: _OnboardingAction.next,
      secondaryAction: _OnboardingAction.back,
      visualKind: _OnboardingVisualKind.forgeSettings,
    ),
    _OnboardingSlideSpec(
      title: 'Forge the prompt',
      body:
          'Generate the prompt, then copy it, share it, or open it directly in your AI workflow from the parchment actions.',
      primaryLabel: 'Start Forging',
      secondaryLabel: 'Back',
      primaryAction: _OnboardingAction.dismiss,
      secondaryAction: _OnboardingAction.back,
      visualKind: _OnboardingVisualKind.parchmentActions,
    ),
  ];

  late final PageController _pageController;
  bool _isVisible = false;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _isVisible = widget.showOnLaunch;
  }

  @override
  void didUpdateWidget(covariant AppLaunchOnboardingGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.showOnLaunch && widget.showOnLaunch) {
      setState(() {
        _currentPageIndex = 0;
        _isVisible = true;
      });
      _pageController.jumpToPage(0);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AbsorbPointer(
          absorbing: _isVisible,
          child: widget.child,
        ),
        if (_isVisible) Positioned.fill(child: _buildOverlay(context)),
      ],
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.fantasy;
    final screenSize = MediaQuery.sizeOf(context);
    final compact = screenSize.width < 720;
    final panelWidthFactor = compact ? 0.94 : 0.88;
    final panelHeightFactor = compact ? 0.80 : 0.70;

    return Material(
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.25,
                colors: <Color>[
                  palette.canvas.withValues(alpha: 0.14),
                  palette.canvas.withValues(alpha: 0.52),
                  Colors.black.withValues(alpha: 0.62),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: FractionallySizedBox(
                widthFactor: panelWidthFactor,
                heightFactor: panelHeightFactor,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1180,
                    maxHeight: 860,
                  ),
                  child: Container(
                    key: const ValueKey<String>('app-onboarding-panel'),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(34),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          Color.lerp(palette.card, palette.cardSoft, 0.38)!
                              .withValues(alpha: 0.97),
                          Color.lerp(
                            palette.cardSoft,
                            FantasyPalette.ember,
                            0.10,
                          )!
                              .withValues(alpha: 0.98),
                        ],
                      ),
                      border: Border.all(
                        color:
                            theme.colorScheme.outline.withValues(alpha: 0.32),
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.34),
                          blurRadius: 40,
                          offset: const Offset(0, 22),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: _slides.length,
                              onPageChanged: (int index) {
                                setState(() {
                                  _currentPageIndex = index;
                                });
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return _OnboardingSlide(
                                  key: ValueKey<int>(index),
                                  slide: _slides[index],
                                  slideCounterText:
                                      '${_currentPageIndex + 1} / ${_slides.length}',
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 14),
                          _buildFooter(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final slide = _slides[_currentPageIndex];
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(
            _slides.length,
            (int index) => AnimatedContainer(
              duration: prefersReducedMotion(context)
                  ? Duration.zero
                  : const Duration(milliseconds: 220),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: index == _currentPageIndex ? 22 : 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: index == _currentPageIndex
                    ? theme.colorScheme.tertiary
                    : theme.colorScheme.outline.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: <Widget>[
            Expanded(
              child: OutlinedButton(
                onPressed: () => _handleAction(slide.secondaryAction),
                child: Text(slide.secondaryLabel),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: () => _handleAction(slide.primaryAction),
                child: Text(slide.primaryLabel),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _handleAction(_OnboardingAction action) async {
    switch (action) {
      case _OnboardingAction.next:
        await _moveToPage(_currentPageIndex + 1);
      case _OnboardingAction.back:
        await _moveToPage(_currentPageIndex - 1);
      case _OnboardingAction.dismiss:
        if (!mounted) {
          return;
        }
        setState(() {
          _isVisible = false;
        });
    }
  }

  Future<void> _moveToPage(int index) async {
    final clampedIndex = index.clamp(0, _slides.length - 1);
    if (clampedIndex == _currentPageIndex) {
      return;
    }

    if (prefersReducedMotion(context)) {
      _pageController.jumpToPage(clampedIndex);
      return;
    }

    await _pageController.animateToPage(
      clampedIndex,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }
}

enum _OnboardingAction {
  back,
  next,
  dismiss,
}

enum _OnboardingVisualKind {
  campaignType,
  forgeSettings,
  parchmentActions,
}

class _OnboardingSlideSpec {
  const _OnboardingSlideSpec({
    required this.title,
    required this.body,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.primaryAction,
    required this.secondaryAction,
    required this.visualKind,
    this.titleFontSizeOffset = 0,
  });

  final String title;
  final String body;
  final String primaryLabel;
  final String secondaryLabel;
  final _OnboardingAction primaryAction;
  final _OnboardingAction secondaryAction;
  final _OnboardingVisualKind visualKind;
  final double titleFontSizeOffset;
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({
    super.key,
    required this.slide,
    required this.slideCounterText,
  });

  final _OnboardingSlideSpec slide;
  final String slideCounterText;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 720;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 920),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final useColumn = isCompact || constraints.maxHeight < 620;
            final isCampaignSlide =
                slide.visualKind == _OnboardingVisualKind.campaignType;
            final visual = _OnboardingVisualCard(kind: slide.visualKind);
            final copy = _OnboardingCopy(
              slide: slide,
              slideCounterText: slideCounterText,
            );
            final compactVisualHeight = isCampaignSlide
                ? constraints.maxWidth.clamp(300.0, 390.0).toDouble()
                : 460.0;
            final compactVisualSpacing = isCampaignSlide ? 16.0 : 24.0;

            if (useColumn) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (isCampaignSlide) ...<Widget>[
                      _OnboardingCopyPanel(child: copy),
                      SizedBox(height: compactVisualSpacing),
                      SizedBox(
                        height: compactVisualHeight,
                        child: visual,
                      ),
                    ] else ...<Widget>[
                      SizedBox(
                        height: compactVisualHeight,
                        child: visual,
                      ),
                      SizedBox(height: compactVisualSpacing),
                      copy,
                    ],
                  ],
                ),
              );
            }

            if (isCampaignSlide) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _OnboardingCopyPanel(child: copy),
                  const SizedBox(height: 20),
                  Expanded(child: visual),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 11,
                  child: visual,
                ),
                const SizedBox(width: 28),
                Expanded(
                  flex: 9,
                  child: _OnboardingCopyPanel(child: copy),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OnboardingCopy extends StatelessWidget {
  const _OnboardingCopy({
    required this.slide,
    required this.slideCounterText,
  });

  final _OnboardingSlideSpec slide;
  final String slideCounterText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.fantasy;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'How it works',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.tertiary,
              ),
            ),
            const Spacer(),
            Text(
              slideCounterText,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.tertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          slide.title,
          style: theme.textTheme.displayMedium?.copyWith(
            color: palette.foreground,
            height: 0.98,
            fontSize: (theme.textTheme.displayMedium?.fontSize ?? 30) +
                slide.titleFontSizeOffset,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          slide.body,
          style: theme.textTheme.titleMedium?.copyWith(
            color: palette.foreground.withValues(alpha: 0.92),
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _OnboardingCopyPanel extends StatelessWidget {
  const _OnboardingCopyPanel({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.fantasy;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.card.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: child,
      ),
    );
  }
}

class _OnboardingVisualCard extends StatelessWidget {
  const _OnboardingVisualCard({
    required this.kind,
  });

  final _OnboardingVisualKind kind;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.fantasy;

    return Container(
      constraints: const BoxConstraints(minHeight: 320),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            palette.card.withValues(alpha: 0.92),
            palette.cardSoft.withValues(alpha: 0.96),
          ],
        ),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: switch (kind) {
          _OnboardingVisualKind.campaignType => const _CampaignTypePreview(),
          _OnboardingVisualKind.forgeSettings => const _ForgeSettingsPreview(),
          _OnboardingVisualKind.parchmentActions =>
            const _ParchmentActionsPreview(),
        },
      ),
    );
  }
}

class _CampaignTypePreview extends StatelessWidget {
  const _CampaignTypePreview();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 1,
      children: <Widget>[
        _PreviewPhotoTile(
          label: 'One-Shot',
          assetPath: 'assets/entry_cards/one_shot.jpg',
          isSelected: true,
        ),
        _PreviewPhotoTile(
          label: 'Mini-campaign',
          assetPath: 'assets/entry_cards/campagna_corta.jpg',
        ),
        _PreviewPhotoTile(
          label: 'Long campaign',
          assetPath: 'assets/entry_cards/campagna_lunga.jpg',
        ),
        _PreviewPhotoTile(
          label: 'Dungeon crawl',
          assetPath: 'assets/entry_cards/dungeon.jpg',
        ),
      ],
    );
  }
}

class _ForgeSettingsPreview extends StatelessWidget {
  const _ForgeSettingsPreview();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _PreviewHeading(
          title: 'Forge inputs',
          subtitle: 'Shape the world before you generate the prompt.',
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: const <Widget>[
            _PreviewRune(label: 'Setting'),
            _PreviewRune(label: 'Themes'),
            _PreviewRune(label: 'Tone'),
            _PreviewRune(label: 'Style'),
            _PreviewRune(label: 'Party'),
            _PreviewRune(label: 'Twist'),
          ],
        ),
        const SizedBox(height: 22),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.54),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.24),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _PreviewField(label: 'Setting', value: 'Shadowed frontier'),
                  SizedBox(height: 12),
                  _PreviewField(label: 'Themes', value: 'Political tension'),
                  SizedBox(height: 12),
                  _PreviewField(label: 'Tone', value: 'Dark but adventurous'),
                  SizedBox(height: 12),
                  _PreviewField(label: 'Style', value: 'Grounded fantasy'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ParchmentActionsPreview extends StatelessWidget {
  const _ParchmentActionsPreview();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.fantasy;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _PreviewHeading(
          title: 'Parchment ready',
          subtitle: 'Generate, then use the final action rail.',
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 10,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: palette.paper.withValues(alpha: 0.95),
                    border: Border.all(
                      color: theme.colorScheme.tertiary.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Campaign prompt',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: palette.paperInk,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const _PreviewParagraph(),
                        const SizedBox(height: 10),
                        const _PreviewParagraph(widthFactor: 0.88),
                        const SizedBox(height: 10),
                        const _PreviewParagraph(widthFactor: 0.72),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 7,
                child: Column(
                  children: const <Widget>[
                    _PreviewActionTile(
                      title: 'Copy',
                      subtitle: 'Keep the prompt ready to paste',
                    ),
                    SizedBox(height: 12),
                    _PreviewActionTile(
                      title: 'Share',
                      subtitle: 'Send it to another app',
                    ),
                    SizedBox(height: 12),
                    _PreviewActionTile(
                      title: 'Open in ChatGPT',
                      subtitle: 'Open the linked AI workflow',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PreviewHeading extends StatelessWidget {
  const _PreviewHeading({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.fantasy;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: theme.textTheme.headlineLarge?.copyWith(
            color: palette.foreground,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: palette.foregroundMuted,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _PreviewPhotoTile extends StatelessWidget {
  const _PreviewPhotoTile({
    required this.label,
    required this.assetPath,
    this.isSelected = false,
  });

  final String label;
  final String assetPath;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = isSelected
        ? theme.colorScheme.tertiary.withValues(alpha: 0.78)
        : theme.colorScheme.outline.withValues(alpha: 0.24);
    final shadow = isSelected
        ? <BoxShadow>[
            BoxShadow(
              color: theme.colorScheme.tertiary.withValues(alpha: 0.18),
              blurRadius: 22,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ]
        : <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.14),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ];

    return Semantics(
      container: true,
      label: '$label preview card',
      selected: isSelected,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: shadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(21),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(assetPath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.black.withValues(alpha: isSelected ? 0.04 : 0.14),
                      Colors.black.withValues(alpha: isSelected ? 0.10 : 0.24),
                      Colors.black.withValues(alpha: isSelected ? 0.42 : 0.72),
                    ],
                  ),
                ),
              ),
              if (!isSelected)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.10),
                  ),
                ),
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: ExcludeSemantics(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: FantasyPalette.parchment,
                      fontSize: 11,
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewRune extends StatelessWidget {
  const _PreviewRune({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.6),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.24),
        ),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.tertiary,
        ),
      ),
    );
  }
}

class _PreviewField extends StatelessWidget {
  const _PreviewField({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.fantasy;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.tertiary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            color: palette.foreground,
          ),
        ),
      ],
    );
  }
}

class _PreviewParagraph extends StatelessWidget {
  const _PreviewParagraph({
    this.widthFactor = 1,
  });

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: 10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: FantasyPalette.ink.withValues(alpha: 0.16),
        ),
      ),
    );
  }
}

class _PreviewActionTile extends StatelessWidget {
  const _PreviewActionTile({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color:
              theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.52),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.24),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.tertiary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
