import 'package:flutter/material.dart';

import '../l10n_extension.dart';
import '../theme/fantasy_theme.dart';
import 'pages/design/campaign_builder_motion.dart';

class AppLaunchOnboardingGate extends StatefulWidget {
  const AppLaunchOnboardingGate({
    super.key,
    required this.child,
    this.showOnLaunch = true,
    this.onDismissed,
  });

  final Widget child;
  final bool showOnLaunch;
  final VoidCallback? onDismissed;

  @override
  State<AppLaunchOnboardingGate> createState() =>
      _AppLaunchOnboardingGateState();
}

class _AppLaunchOnboardingGateState extends State<AppLaunchOnboardingGate> {
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
      _resetToFirstPageWhenReady();
    }
  }

  void _resetToFirstPageWhenReady() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_pageController.hasClients) {
        return;
      }
      _pageController.jumpToPage(0);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<_OnboardingSlideSpec> _slides(BuildContext context) {
    final l10n = context.l10n;
    return <_OnboardingSlideSpec>[
      _OnboardingSlideSpec(
        title: l10n.onboardingChooseCampaignTitle,
        body: l10n.onboardingChooseCampaignBody,
        primaryLabel: l10n.onboardingNext,
        secondaryLabel: l10n.onboardingSkip,
        primaryAction: _OnboardingAction.next,
        secondaryAction: _OnboardingAction.dismiss,
        visualKind: _OnboardingVisualKind.campaignType,
        titleFontSizeOffset: -7,
      ),
      _OnboardingSlideSpec(
        title: l10n.onboardingDefineDetailsTitle,
        body: l10n.onboardingDefineDetailsBody,
        primaryLabel: l10n.onboardingNext,
        secondaryLabel: l10n.onboardingBack,
        primaryAction: _OnboardingAction.next,
        secondaryAction: _OnboardingAction.back,
        visualKind: _OnboardingVisualKind.forgeSettings,
        titleFontSizeOffset: -9,
      ),
      _OnboardingSlideSpec(
        title: l10n.onboardingForgePromptTitle,
        body: l10n.onboardingForgePromptBody,
        primaryLabel: l10n.onboardingStartForging,
        secondaryLabel: l10n.onboardingBack,
        primaryAction: _OnboardingAction.dismiss,
        secondaryAction: _OnboardingAction.back,
        visualKind: _OnboardingVisualKind.parchmentActions,
        titleFontSizeOffset: -9,
      ),
    ];
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
    final slides = _slides(context);
    final screenSize = MediaQuery.sizeOf(context);
    final compact = screenSize.width < 720;
    final panelWidthFactor = compact ? 0.94 : 0.88;
    final panelHeightFactor = compact ? 0.72 : 0.62;

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
                    maxHeight: 820,
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
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: slides.length,
                              onPageChanged: (int index) {
                                setState(() {
                                  _currentPageIndex = index;
                                });
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return _OnboardingSlide(
                                  key: ValueKey<int>(index),
                                  slide: slides[index],
                                  slideCounterText:
                                      '${_currentPageIndex + 1} / ${slides.length}',
                                );
                              },
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: _buildFooter(context, slides),
                          ),
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

  Widget _buildFooter(
    BuildContext context,
    List<_OnboardingSlideSpec> slides,
  ) {
    final slide = slides[_currentPageIndex];
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(
            slides.length,
            (int index) => AnimatedContainer(
              duration: prefersReducedMotion(context)
                  ? Duration.zero
                  : const Duration(milliseconds: 220),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: index == _currentPageIndex ? 22 : 7,
              height: 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: index == _currentPageIndex
                    ? theme.colorScheme.tertiary
                    : theme.colorScheme.outline.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => _handleAction(slide.primaryAction),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(42),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                ),
                child: Text(slide.primaryLabel),
              ),
            ),
          ),
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
        widget.onDismissed?.call();
    }
  }

  Future<void> _moveToPage(int index) async {
    final clampedIndex = index.clamp(0, 2);
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
            final isForgeSettingsSlide =
                slide.visualKind == _OnboardingVisualKind.forgeSettings;
            final isParchmentSlide =
                slide.visualKind == _OnboardingVisualKind.parchmentActions;
            final usesStackedPanels =
                isCampaignSlide || isForgeSettingsSlide || isParchmentSlide;
            final visual = _OnboardingVisualCard(kind: slide.visualKind);
            final copy = _OnboardingCopy(
              slide: slide,
              slideCounterText: slideCounterText,
            );
            final compactVisualHeight = isCampaignSlide
                ? constraints.maxWidth.clamp(300.0, 390.0).toDouble()
                : isForgeSettingsSlide
                    ? constraints.maxWidth.clamp(300.0, 380.0).toDouble()
                    : constraints.maxWidth.clamp(300.0, 380.0).toDouble();
            final compactVisualSpacing = usesStackedPanels ? 16.0 : 24.0;

            if (useColumn) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (usesStackedPanels) ...<Widget>[
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

            if (usesStackedPanels) {
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
    final l10n = context.l10n;
    final subtitleColor =
        slide.visualKind == _OnboardingVisualKind.parchmentActions
            ? palette.foreground.withValues(alpha: 0.92)
            : theme.colorScheme.tertiary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              l10n.onboardingHowItWorks,
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
            color: subtitleColor,
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
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
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
    final bottomInset = switch (kind) {
      _OnboardingVisualKind.campaignType => 56.0,
      _OnboardingVisualKind.forgeSettings => 0.0,
      _OnboardingVisualKind.parchmentActions => 0.0,
    };

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
        padding: EdgeInsets.fromLTRB(24, 24, 24, bottomInset),
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
    final l10n = context.l10n;

    return Column(
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                child: _PreviewPhotoTile(
                  label: l10n.helpCampaignTypeOneShotTitle,
                  assetPath: 'assets/entry_cards/one_shot.jpg',
                  isSelected: true,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _PreviewPhotoTile(
                  label: l10n.helpCampaignTypeMiniCampaignTitle,
                  assetPath: 'assets/entry_cards/campagna_corta.jpg',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                child: _PreviewPhotoTile(
                  label: l10n.helpCampaignTypeLongCampaignTitle,
                  assetPath: 'assets/entry_cards/campagna_lunga.jpg',
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _PreviewPhotoTile(
                  label: l10n.helpCampaignTypeDungeonTitle,
                  assetPath: 'assets/entry_cards/dungeon.jpg',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ForgeSettingsPreview extends StatelessWidget {
  const _ForgeSettingsPreview();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final chips = Wrap(
      spacing: 2,
      runSpacing: 7,
      children: <Widget>[
        _PreviewRune(label: l10n.forgeSettingLabel, isActive: true),
        _PreviewRune(label: l10n.forgeThemesTitle),
        _PreviewRune(label: l10n.forgeToneTitle),
        _PreviewRune(label: l10n.forgeStyleTitle),
        _PreviewRune(label: l10n.forgeSectionParty),
        _PreviewRune(label: l10n.forgeTwistLabel),
      ],
    );

    final summaryContent = Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          chips,
          const SizedBox(height: 14),
          _PreviewField(
            label: l10n.forgeSettingLabel,
            value: l10n.onboardingSettingExample,
            isActive: true,
          ),
          const SizedBox(height: 8),
          _PreviewField(
            label: l10n.forgeThemesTitle,
            value: l10n.onboardingThemesExample,
          ),
          const SizedBox(height: 6),
          _PreviewField(
            label: l10n.forgeToneTitle,
            value: l10n.onboardingToneExample,
          ),
          const SizedBox(height: 6),
          _PreviewField(
            label: l10n.forgeStyleTitle,
            value: l10n.onboardingStyleExample,
          ),
        ],
      ),
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxHeight < 320) {
          return SingleChildScrollView(child: summaryContent);
        }

        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints summaryConstraints) {
            const footerBleed = 30.0;

            return OverflowBox(
              alignment: Alignment.topCenter,
              minHeight: summaryConstraints.maxHeight + footerBleed,
              maxHeight: summaryConstraints.maxHeight + footerBleed,
              child: SizedBox(
                width: double.infinity,
                height: summaryConstraints.maxHeight + footerBleed,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: summaryContent,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ParchmentActionsPreview extends StatelessWidget {
  const _ParchmentActionsPreview();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints panelConstraints) {
        final compactContent = panelConstraints.maxWidth < 560;
        final content = compactContent
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _PromptPreviewCard(),
                    const SizedBox(height: 14),
                    _ParchmentActionFlow(),
                  ],
                ),
              )
            : Row(
                children: <Widget>[
                  Expanded(
                    flex: 11,
                    child: _PromptPreviewCard(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 9,
                    child: _ParchmentActionFlow(),
                  ),
                ],
              );

        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _PreviewStepChip(step: '1', label: l10n.appStageForge),
                      const SizedBox(width: 8),
                      _PreviewStepChip(
                        step: '2',
                        label: l10n.onboardingCopyStep,
                        isActive: true,
                      ),
                      const SizedBox(width: 8),
                      _PreviewStepChip(
                        step: '3',
                        label: 'ChatGPT',
                        isCurrent: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(child: content),
            ],
          ),
        );
      },
    );
  }
}

class _PromptPreviewCard extends StatelessWidget {
  const _PromptPreviewCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.fantasy;
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            palette.paper.withValues(alpha: 0.98),
            Color.lerp(palette.paper, FantasyPalette.parchment, 0.18)!,
          ],
        ),
        border: Border.all(
          color: theme.colorScheme.tertiary.withValues(alpha: 0.34),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              l10n.onboardingGeneratedPromptTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                color: palette.paperInk,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            const _PreviewParagraph(),
            const SizedBox(height: 4),
            const _PreviewParagraph(widthFactor: 0.90),
            const SizedBox(height: 4),
            const _PreviewParagraph(widthFactor: 0.82),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                _PromptTag(label: l10n.forgeSettingLabel),
                _PromptTag(label: l10n.forgeToneTitle),
                _PromptTag(label: l10n.forgeSectionParty),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PromptTag extends StatelessWidget {
  const _PromptTag({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.fantasy;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: palette.paperInk.withValues(alpha: 0.08),
        border: Border.all(
          color: palette.paperInk.withValues(alpha: 0.12),
        ),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: palette.paperInk.withValues(alpha: 0.78),
        ),
      ),
    );
  }
}

class _ParchmentActionFlow extends StatelessWidget {
  const _ParchmentActionFlow();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _PreviewActionTile(
          title: l10n.parchmentOpenChatGptTitle,
          subtitle: l10n.onboardingPastePromptSubtitle,
          emphasis: _PreviewActionTileEmphasis.primary,
        ),
      ],
    );
  }
}

class _PreviewStepChip extends StatelessWidget {
  const _PreviewStepChip({
    required this.step,
    required this.label,
    this.isActive = false,
    this.isCurrent = false,
  });

  final String step;
  final String label;
  final bool isActive;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.fantasy;

    final gradient = isCurrent
        ? <Color>[
            theme.colorScheme.tertiary.withValues(alpha: 0.96),
            theme.colorScheme.primary.withValues(alpha: 0.86),
          ]
        : isActive
            ? <Color>[
                theme.colorScheme.tertiaryContainer.withValues(alpha: 0.72),
                theme.colorScheme.primaryContainer.withValues(alpha: 0.58),
              ]
            : <Color>[
                palette.card.withValues(alpha: 0.72),
                palette.cardSoft.withValues(alpha: 0.84),
              ];

    final borderColor = isCurrent
        ? theme.colorScheme.tertiary.withValues(alpha: 0.60)
        : isActive
            ? theme.colorScheme.tertiary.withValues(alpha: 0.36)
            : theme.colorScheme.outline.withValues(alpha: 0.18);

    final textColor = isCurrent
        ? theme.colorScheme.onTertiary
        : isActive
            ? theme.colorScheme.tertiary
            : palette.foregroundMuted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        border: Border.all(color: borderColor),
        boxShadow: isCurrent
            ? <BoxShadow>[
                BoxShadow(
                  color: theme.colorScheme.tertiary.withValues(alpha: 0.18),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 16,
            height: 16,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCurrent
                  ? Colors.black.withValues(alpha: 0.16)
                  : theme.colorScheme.tertiary.withValues(alpha: 0.12),
            ),
            child: Text(
              step,
              style: theme.textTheme.labelSmall?.copyWith(
                color: textColor,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: textColor,
              fontSize: label == 'ChatGPT' ? 10 : 11,
              fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
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
    this.isActive = false,
  });

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isActive
              ? <Color>[
                  theme.colorScheme.primaryContainer.withValues(alpha: 0.88),
                  theme.colorScheme.tertiaryContainer.withValues(alpha: 0.58),
                ]
              : <Color>[
                  theme.colorScheme.primaryContainer.withValues(alpha: 0.30),
                  theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.22,
                  ),
                ],
        ),
        border: Border.all(
          color: isActive
              ? theme.colorScheme.tertiary.withValues(alpha: 0.55)
              : theme.colorScheme.outline.withValues(alpha: 0.18),
        ),
        boxShadow: isActive
            ? <BoxShadow>[
                BoxShadow(
                  color: theme.colorScheme.tertiary.withValues(alpha: 0.14),
                  blurRadius: 12,
                  offset: const Offset(0, 7),
                ),
              ]
            : null,
      ),
      child: Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(
          color: isActive
              ? theme.colorScheme.tertiary
              : theme.colorScheme.tertiary.withValues(alpha: 0.68),
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
          fontSize: 12,
          letterSpacing: 0.15,
        ),
      ),
    );
  }
}

class _PreviewField extends StatelessWidget {
  const _PreviewField({
    required this.label,
    required this.value,
    this.isActive = false,
  });

  final String label;
  final String value;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.fantasy;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isActive
            ? theme.colorScheme.tertiaryContainer.withValues(alpha: 0.18)
            : Colors.transparent,
        border: Border.all(
          color: isActive
              ? theme.colorScheme.tertiary.withValues(alpha: 0.24)
              : theme.colorScheme.outline.withValues(alpha: 0.10),
          width: isActive ? 1.0 : 0.6,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: isActive
                  ? theme.colorScheme.tertiary
                  : theme.colorScheme.tertiary.withValues(alpha: 0.64),
              fontSize: 11,
              letterSpacing: 0.18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              color: palette.foreground,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
              height: 1.12,
            ),
          ),
        ],
      ),
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

enum _PreviewActionTileEmphasis {
  secondary,
  primary,
}

class _PreviewActionTile extends StatelessWidget {
  const _PreviewActionTile({
    required this.title,
    required this.subtitle,
    this.emphasis = _PreviewActionTileEmphasis.secondary,
  });

  final String title;
  final String subtitle;
  final _PreviewActionTileEmphasis emphasis;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPrimary = emphasis == _PreviewActionTileEmphasis.primary;
    final backgroundGradient = isPrimary
        ? <Color>[
            theme.colorScheme.tertiary.withValues(alpha: 0.94),
            theme.colorScheme.primary.withValues(alpha: 0.84),
          ]
        : <Color>[
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.42),
            theme.colorScheme.primaryContainer.withValues(alpha: 0.18),
          ];
    final borderColor = isPrimary
        ? theme.colorScheme.tertiary.withValues(alpha: 0.58)
        : theme.colorScheme.outline.withValues(alpha: 0.24);
    final titleColor =
        isPrimary ? theme.colorScheme.onTertiary : theme.colorScheme.tertiary;
    final subtitleColor = isPrimary
        ? theme.colorScheme.onTertiary.withValues(alpha: 0.82)
        : theme.colorScheme.onSurface.withValues(alpha: 0.78);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: backgroundGradient,
        ),
        border: Border.all(color: borderColor),
        boxShadow: isPrimary
            ? <BoxShadow>[
                BoxShadow(
                  color: theme.colorScheme.tertiary.withValues(alpha: 0.16),
                  blurRadius: 16,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: titleColor,
              fontWeight: isPrimary ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: subtitleColor,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
