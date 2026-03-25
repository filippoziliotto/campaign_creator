import 'package:flutter/material.dart';

import '../../../l10n_extension.dart';
import '../../../theme/fantasy_theme.dart';
import '../design/campaign_builder_atmosphere.dart';

class PromptChapter {
  const PromptChapter({
    required this.index,
    required this.title,
    required this.body,
    required this.preview,
    required this.icon,
  });

  final int index;
  final String title;
  final String body;
  final String preview;
  final IconData icon;
}

List<PromptChapter> parsePromptChapters(String prompt) {
  final normalized = prompt.replaceAll('\r\n', '\n').trim();
  if (normalized.isEmpty) {
    return const <PromptChapter>[];
  }

  final blocks = normalized
      .split(RegExp(r'\n\s*\n+'))
      .map((block) => block.trim())
      .where((block) => block.isNotEmpty)
      .toList();

  const fallbackTitles = <String>[
    'Invocazione',
    'Premessa',
    'Nucleo della campagna',
    'Escalation',
    'Snodi chiave',
    'Materiale di gioco',
    'Dettagli finali',
  ];

  const fallbackIcons = <IconData>[
    Icons.auto_awesome_rounded,
    Icons.landscape_rounded,
    Icons.local_fire_department_rounded,
    Icons.hub_rounded,
    Icons.menu_book_rounded,
    Icons.shield_moon_rounded,
    Icons.check_circle_outline_rounded,
  ];

  final chapters = <PromptChapter>[];
  var fallbackIndex = 0;

  for (final block in blocks) {
    final lines = block
        .split('\n')
        .map((line) => line.trimRight())
        .where((line) => line.trim().isNotEmpty)
        .toList();
    if (lines.isEmpty) {
      continue;
    }

    final firstLine = lines.first.trim();
    late final String title;
    late final String body;

    if (_looksLikeHeading(firstLine) && lines.length > 1) {
      title = _normalizeHeading(firstLine);
      body = lines.skip(1).join('\n').trim();
    } else {
      title = fallbackTitles[fallbackIndex % fallbackTitles.length];
      body = block;
      fallbackIndex += 1;
    }

    final preview = _buildPreview(body);
    final icon = fallbackIcons[chapters.length % fallbackIcons.length];

    chapters.add(
      PromptChapter(
        index: chapters.length + 1,
        title: title,
        body: body,
        preview: preview,
        icon: icon,
      ),
    );
  }

  if (chapters.isNotEmpty) {
    return chapters;
  }

  return <PromptChapter>[
    PromptChapter(
      index: 1,
      title: 'Pergamena completa',
      body: normalized,
      preview: _buildPreview(normalized),
      icon: Icons.description_rounded,
    ),
  ];
}

class ParchmentUnfoldReveal extends StatefulWidget {
  const ParchmentUnfoldReveal({
    super.key,
    required this.atmosphere,
    required this.child,
  });

  final CampaignAtmosphereData atmosphere;
  final Widget child;

  @override
  State<ParchmentUnfoldReveal> createState() => _ParchmentUnfoldRevealState();
}

class _ParchmentUnfoldRevealState extends State<ParchmentUnfoldReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool get _reducedMotion =>
      MediaQuery.maybeOf(context)?.disableAnimations ?? false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.atmosphere.parchmentUnfoldDuration,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant ParchmentUnfoldReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.atmosphere.parchmentUnfoldDuration !=
        widget.atmosphere.parchmentUnfoldDuration) {
      _controller.duration = widget.atmosphere.parchmentUnfoldDuration;
    }
    _syncAnimation();
  }

  void _syncAnimation() {
    if (_reducedMotion) {
      _controller.value = 1;
      return;
    }

    if (_controller.status == AnimationStatus.dismissed &&
        _controller.value == 0) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.atmosphere.parchmentUnfoldCurve,
    );

    return AnimatedBuilder(
      animation: curvedAnimation,
      child: widget.child,
      builder: (context, child) {
        final progress = _reducedMotion ? 1.0 : curvedAnimation.value;
        final heightFactor = 0.16 + (progress * 0.84);
        final verticalScale = 0.88 + (progress * 0.12);
        final opacity =
            _reducedMotion ? 1.0 : Curves.easeOut.transform(progress);
        final glowAlpha = 0.04 + (progress * 0.08);

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, (1 - progress) * 18),
            child: ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: heightFactor,
                child: Transform.scale(
                  alignment: Alignment.topCenter,
                  scaleX: 1,
                  scaleY: verticalScale,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: widget.atmosphere.glow
                              .withValues(alpha: glowAlpha),
                          blurRadius: 14 + (progress * 12),
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ParchmentSummonReveal extends StatefulWidget {
  const ParchmentSummonReveal({
    super.key,
    required this.atmosphere,
    required this.child,
  });

  final CampaignAtmosphereData atmosphere;
  final Widget child;

  @override
  State<ParchmentSummonReveal> createState() => _ParchmentSummonRevealState();
}

class _ParchmentSummonRevealState extends State<ParchmentSummonReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool get _reducedMotion =>
      MediaQuery.maybeOf(context)?.disableAnimations ?? false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.atmosphere.parchmentUnfoldDuration,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant ParchmentSummonReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.atmosphere.parchmentUnfoldDuration !=
        widget.atmosphere.parchmentUnfoldDuration) {
      _controller.duration = widget.atmosphere.parchmentUnfoldDuration;
    }
    _syncAnimation();
  }

  void _syncAnimation() {
    if (_reducedMotion) {
      _controller.value = 1;
      return;
    }
    if (_controller.status == AnimationStatus.dismissed &&
        _controller.value == 0) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.atmosphere.parchmentUnfoldCurve,
    );

    return AnimatedBuilder(
      animation: curvedAnimation,
      child: widget.child,
      builder: (context, child) {
        final progress = _reducedMotion ? 1.0 : curvedAnimation.value;
        final opacity = Curves.easeOut.transform(progress);
        final translateY = (1.0 - progress) * 10.0;
        final scale = 0.98 + (progress * 0.02);

        return Opacity(
          opacity: opacity,
          child: Transform(
            transform: Matrix4.identity()
              ..translateByDouble(0.0, translateY, 0.0, 1.0)
              ..scaleByDouble(scale, scale, scale, 1.0),
            alignment: Alignment.topCenter,
            child: child,
          ),
        );
      },
    );
  }
}

class PremiumParchmentSheet extends StatelessWidget {
  const PremiumParchmentSheet({
    super.key,
    required this.atmosphere,
    required this.chapters,
    required this.prompt,
    required this.isStale,
    required this.onSealTap,
  });

  final CampaignAtmosphereData atmosphere;
  final List<PromptChapter> chapters;
  final String prompt;
  final bool isStale;
  final VoidCallback onSealTap;

  @override
  Widget build(BuildContext context) {
    final highlightChapters = chapters.take(3).toList(growable: false);
    final palette = context.fantasy;
    final words = prompt
        .split(RegExp(r'\s+'))
        .where((token) => token.trim().isNotEmpty)
        .length;

    return Container(
      key: const ValueKey('parchment-outer-shell'),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.24),
            blurRadius: 26,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: atmosphere.primary.withValues(alpha: 0.2),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color.lerp(palette.card, atmosphere.cardTint, 0.12)!
                  .withValues(alpha: 0.98),
              Color.lerp(palette.cardSoft, atmosphere.cardTint, 0.2)!
                  .withValues(alpha: 0.98),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _ParchmentStatChip(
                  label: '${chapters.length} capitoli',
                  icon: Icons.library_books_rounded,
                  atmosphere: atmosphere,
                ),
                _ParchmentStatChip(
                  label: '$words parole',
                  icon: Icons.text_fields_rounded,
                  atmosphere: atmosphere,
                ),
                _ParchmentStatChip(
                  label: atmosphere.label,
                  icon: Icons.auto_awesome_rounded,
                  atmosphere: atmosphere,
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (isStale) ...[
              _ParchmentBanner(
                atmosphere: atmosphere,
                icon: Icons.refresh_rounded,
                text:
                    'Hai modificato la forgia dopo l ultima generazione. La pergamena visibile e precedente rispetto allo stato attuale.',
              ),
              const SizedBox(height: 18),
            ],
            if (highlightChapters.isNotEmpty) ...[
              Container(
                key: const ValueKey('parchment-highlight-strip'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Capitoli in evidenza',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 14,
                      runSpacing: 14,
                      children: highlightChapters.map((chapter) {
                        return SizedBox(
                          width: 240,
                          child: _ParchmentHighlightCard(
                            atmosphere: atmosphere,
                            chapter: chapter,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
            ],
            _ParchmentBodyFrame(
              key: const ValueKey('parchment-body-frame'),
              atmosphere: atmosphere,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final compact = constraints.maxWidth < 680;
                      final header = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pergamena del Cronista',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: FantasyPalette.ink,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Una lettura strutturata del prompt finale, con capitoli richiudibili e punti chiave messi in rilievo.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: FantasyPalette.ink
                                      .withValues(alpha: 0.76),
                                ),
                          ),
                        ],
                      );

                      final seal = _WaxSealReveal(
                        key: const ValueKey('parchment-wax-seal-reveal'),
                        atmosphere: atmosphere,
                        child: _WaxSealButton(
                          key: const ValueKey('parchment-wax-seal-full'),
                          atmosphere: atmosphere,
                          onTap: onSealTap,
                        ),
                      );

                      if (compact) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            header,
                            const SizedBox(height: 16),
                            seal,
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: header),
                          const SizedBox(width: 18),
                          seal,
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  ...chapters.map((chapter) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _PromptChapterTile(
                        atmosphere: atmosphere,
                        chapter: chapter,
                      ),
                    );
                  }),
                  _PromptRawTextTile(
                    atmosphere: atmosphere,
                    prompt: prompt,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParchmentBodyFrame extends StatelessWidget {
  const _ParchmentBodyFrame({
    super.key,
    required this.atmosphere,
    required this.child,
  });

  final CampaignAtmosphereData atmosphere;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final frameTint = Color.lerp(
      FantasyPalette.parchmentDeep,
      atmosphere.primary,
      0.14,
    )!;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 420),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: atmosphere.primary.withValues(alpha: 0.2),
          width: 1.2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            frameTint.withValues(alpha: 0.32),
            const Color(0xFFF2E2BC),
            const Color(0xFFE0C694),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    const Color(0xFFF8EED7),
                    Color.lerp(
                      FantasyPalette.parchment,
                      atmosphere.highlight,
                      0.18,
                    )!,
                    const Color(0xFFE3C78F),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: FantasyPalette.ink.withValues(alpha: 0.08),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: atmosphere.primary.withValues(alpha: 0.08),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _WaxSealReveal extends StatelessWidget {
  const _WaxSealReveal({
    super.key,
    required this.atmosphere,
    required this.child,
  });

  final CampaignAtmosphereData atmosphere;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final reducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reducedMotion) {
      return child;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: atmosphere.parchmentUnfoldDuration +
          const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final opacity = Curves.easeOut.transform(value);
        final scale = 0.9 + (value * 0.1);
        final translateY = (1 - value) * 14;
        final glowAlpha = 0.04 + (value * 0.08);

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, translateY),
            child: Transform.scale(
              scale: scale,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: atmosphere.glow.withValues(alpha: glowAlpha),
                      blurRadius: 18 + (value * 8),
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: child,
              ),
            ),
          ),
        );
      },
      child: child,
    );
  }
}

class ForgedParchmentSuccessSheet extends StatelessWidget {
  const ForgedParchmentSuccessSheet({
    super.key,
    required this.atmosphere,
    required this.isStale,
    required this.onSealTap,
  });

  final CampaignAtmosphereData atmosphere;
  final bool isStale;
  final VoidCallback onSealTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.fantasy;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.24),
            blurRadius: 26,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 420),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: atmosphere.primary.withValues(alpha: 0.2),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color.lerp(palette.card, atmosphere.cardTint, 0.12)!
                  .withValues(alpha: 0.98),
              Color.lerp(palette.cardSoft, atmosphere.cardTint, 0.2)!
                  .withValues(alpha: 0.98),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _ParchmentStatChip(
                  label: context.l10n.parchmentPromptCopied,
                  icon: Icons.check_circle_outline_rounded,
                  atmosphere: atmosphere,
                ),
                _ParchmentStatChip(
                  label: _localizedAtmosphereLabel(context, atmosphere),
                  icon: Icons.auto_awesome_rounded,
                  atmosphere: atmosphere,
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (isStale) ...[
              _ParchmentBanner(
                atmosphere: atmosphere,
                icon: Icons.refresh_rounded,
                text: context.l10n.parchmentCopiedStaleBanner,
              ),
              const SizedBox(height: 18),
            ],
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _WaxSealReveal(
                        atmosphere: atmosphere,
                        child: _WaxSealButton(
                          atmosphere: atmosphere,
                          onTap: onSealTap,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        context.l10n.parchmentPromptCopied,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        context.l10n.parchmentCopiedSuccessBody,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ParchmentActionRail extends StatelessWidget {
  const ParchmentActionRail({
    super.key,
    required this.atmosphere,
    required this.onCopy,
    required this.onShare,
    required this.onOpenChatGpt,
    required this.onSaveDraft,
    required this.onWaxSealTap,
    required this.isCurrentDraftSaved,
    this.savedDraftLabel,
  });

  final CampaignAtmosphereData atmosphere;
  final VoidCallback onCopy;
  final ValueChanged<Rect> onShare;
  final VoidCallback onOpenChatGpt;
  final VoidCallback onSaveDraft;
  final VoidCallback onWaxSealTap;
  final bool isCurrentDraftSaved;
  final String? savedDraftLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                context.l10n.parchmentQuickActionsTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            _WaxSealButton(
              atmosphere: atmosphere,
              compact: true,
              onTap: onWaxSealTap,
            ),
          ],
        ),
        const SizedBox(height: 12),
        _ActionRailTile(
          key: const ValueKey('parchment-action-copy'),
          atmosphere: atmosphere,
          icon: Icons.copy_rounded,
          title: context.l10n.parchmentCopyPromptTitle,
          subtitle: context.l10n.parchmentCopyPromptSubtitle,
          onTap: onCopy,
        ),
        const SizedBox(height: 10),
        _ActionRailTile(
          key: const ValueKey('parchment-action-share'),
          atmosphere: atmosphere,
          icon: Icons.ios_share_rounded,
          title: context.l10n.parchmentShareTitle,
          subtitle: context.l10n.parchmentShareSubtitle,
          onTapWithRect: onShare,
        ),
        const SizedBox(height: 10),
        _ActionRailTile(
          key: const ValueKey('parchment-action-open-chatgpt'),
          atmosphere: atmosphere,
          icon: Icons.open_in_new_rounded,
          title: context.l10n.parchmentOpenChatGptTitle,
          subtitle: context.l10n.parchmentOpenChatGptSubtitle,
          onTap: onOpenChatGpt,
        ),
        const SizedBox(height: 10),
        _ActionRailTile(
          key: const ValueKey('parchment-action-save-draft'),
          atmosphere: atmosphere,
          icon: isCurrentDraftSaved
              ? Icons.bookmark_added_rounded
              : Icons.bookmark_border_rounded,
          title: isCurrentDraftSaved
              ? context.l10n.parchmentDraftUpdatedTitle
              : context.l10n.parchmentSaveDraftTitle,
          subtitle: savedDraftLabel ?? context.l10n.parchmentSaveDraftSubtitle,
          onTap: onSaveDraft,
        ),
      ],
    );
  }
}

String _localizedAtmosphereLabel(
  BuildContext context,
  CampaignAtmosphereData atmosphere,
) {
  switch (atmosphere.id) {
    case 'one-shot':
      return context.l10n.atmosphereOneShot;
    case 'mini-campaign':
      return context.l10n.atmosphereMiniCampaign;
    case 'long-campaign':
      return context.l10n.atmosphereLongCampaign;
    case 'dungeon':
      return context.l10n.atmosphereDungeon;
    default:
      return atmosphere.label;
  }
}

bool _looksLikeHeading(String line) {
  final trimmed = line.trim();
  if (trimmed.isEmpty || trimmed.length > 72) {
    return false;
  }
  if (trimmed.startsWith('#')) {
    return true;
  }
  if (trimmed.endsWith(':')) {
    return true;
  }
  return RegExp(r"^[A-Z0-9][A-Za-z0-9À-ÿ ,\-'’/]{3,48}$").hasMatch(trimmed) &&
      !trimmed.contains('.');
}

String _normalizeHeading(String line) {
  final normalized = line.replaceAll(RegExp(r'^#+\s*'), '').trim();
  return normalized.endsWith(':')
      ? normalized.substring(0, normalized.length - 1).trim()
      : normalized;
}

String _buildPreview(String body) {
  final collapsed =
      body.replaceAll('\n', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  if (collapsed.length <= 144) {
    return collapsed;
  }
  return '${collapsed.substring(0, 141).trim()}...';
}

class _ParchmentStatChip extends StatelessWidget {
  const _ParchmentStatChip({
    required this.label,
    required this.icon,
    required this.atmosphere,
  });

  final String label;
  final IconData icon;
  final CampaignAtmosphereData atmosphere;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: atmosphere.primary.withValues(alpha: 0.05),
        border: Border.all(
          color: atmosphere.primary.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: atmosphere.primary.withValues(alpha: 0.1),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 12,
              color: atmosphere.primary.withValues(alpha: 0.88),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withValues(alpha: 0.88),
                ),
          ),
        ],
      ),
    );
  }
}

class _ParchmentBanner extends StatelessWidget {
  const _ParchmentBanner({
    required this.atmosphere,
    required this.icon,
    required this.text,
  });

  final CampaignAtmosphereData atmosphere;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: atmosphere.primary.withValues(alpha: 0.12),
        border: Border.all(
          color: atmosphere.primary.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: atmosphere.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _ParchmentHighlightCard extends StatelessWidget {
  const _ParchmentHighlightCard({
    required this.atmosphere,
    required this.chapter,
  });

  final CampaignAtmosphereData atmosphere;
  final PromptChapter chapter;

  @override
  Widget build(BuildContext context) {
    final palette = context.fantasy;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Color.lerp(
          palette.cardSoft,
          atmosphere.primary,
          0.16,
        )!
            .withValues(alpha: 0.28),
        border: Border.all(
          color: atmosphere.primary.withValues(alpha: 0.28),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: atmosphere.glow.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: atmosphere.primary.withValues(alpha: 0.18),
                  border: Border.all(
                    color: atmosphere.highlight.withValues(alpha: 0.16),
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  chapter.icon,
                  size: 18,
                  color: atmosphere.highlight,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  chapter.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            chapter.preview,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  height: 1.45,
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withValues(alpha: 0.84),
                ),
          ),
        ],
      ),
    );
  }
}

class _PromptChapterTile extends StatefulWidget {
  const _PromptChapterTile({
    required this.atmosphere,
    required this.chapter,
  });

  final CampaignAtmosphereData atmosphere;
  final PromptChapter chapter;

  @override
  State<_PromptChapterTile> createState() => _PromptChapterTileState();
}

class _PromptChapterTileState extends State<_PromptChapterTile> {
  bool _expanded = false;

  bool get _reducedMotion =>
      MediaQuery.maybeOf(context)?.disableAnimations ?? false;

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final atmosphere = widget.atmosphere;
    final chapter = widget.chapter;
    final duration = _reducedMotion
        ? const Duration(milliseconds: 120)
        : const Duration(milliseconds: 220);

    return AnimatedContainer(
      duration: duration,
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _expanded
              ? atmosphere.primary.withValues(alpha: 0.24)
              : FantasyPalette.ink.withValues(alpha: 0.1),
        ),
        color: Color.lerp(
          const Color(0xFFF7EDD8),
          atmosphere.highlight,
          0.06,
        )!
            .withValues(alpha: _expanded ? 0.94 : 0.88),
        boxShadow: _expanded
            ? <BoxShadow>[
                BoxShadow(
                  color: atmosphere.glow.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 12),
                ),
              ]
            : const <BoxShadow>[],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            key: ValueKey('parchment-chapter-${chapter.index}'),
            onTap: _toggleExpanded,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: atmosphere.primary.withValues(alpha: 0.12),
                      border: Border.all(
                        color: atmosphere.primary.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          chapter.icon,
                          size: 15,
                          color: atmosphere.primary.withValues(alpha: 0.9),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          chapter.index.toString().padLeft(2, '0'),
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: FantasyPalette.ink,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          key: ValueKey(
                              'parchment-chapter-meta-${chapter.index}'),
                          children: [
                            Icon(
                              chapter.icon,
                              size: 14,
                              color: atmosphere.primary.withValues(alpha: 0.88),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              chapter.index.toString().padLeft(2, '0'),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: FantasyPalette.ink
                                        .withValues(alpha: 0.66),
                                    letterSpacing: 1.1,
                                  ),
                            ),
                            const Spacer(),
                            AnimatedRotation(
                              turns: _expanded ? 0.5 : 0,
                              duration: duration,
                              curve: Curves.easeOutCubic,
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color:
                                    FantasyPalette.ink.withValues(alpha: 0.72),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          chapter.title,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: FantasyPalette.ink,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          chapter.preview,
                          maxLines: _expanded ? 4 : 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color:
                                    FantasyPalette.ink.withValues(alpha: 0.7),
                                height: 1.45,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ClipRect(
            child: AnimatedSize(
              duration: duration,
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: _expanded
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            key: ValueKey(
                              'parchment-chapter-divider-${chapter.index}',
                            ),
                            height: 1,
                            color: FantasyPalette.ink.withValues(alpha: 0.1),
                          ),
                          const SizedBox(height: 14),
                          SelectableText(
                            chapter.body,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: FantasyPalette.ink,
                                  height: 1.62,
                                ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PromptRawTextTile extends StatefulWidget {
  const _PromptRawTextTile({
    required this.atmosphere,
    required this.prompt,
  });

  final CampaignAtmosphereData atmosphere;
  final String prompt;

  @override
  State<_PromptRawTextTile> createState() => _PromptRawTextTileState();
}

class _PromptRawTextTileState extends State<_PromptRawTextTile> {
  bool _expanded = false;

  bool get _reducedMotion =>
      MediaQuery.maybeOf(context)?.disableAnimations ?? false;

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final atmosphere = widget.atmosphere;
    final duration = _reducedMotion
        ? const Duration(milliseconds: 120)
        : const Duration(milliseconds: 220);

    return AnimatedContainer(
      duration: duration,
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: FantasyPalette.ink.withValues(alpha: _expanded ? 0.14 : 0.08),
        ),
        color: Colors.white.withValues(alpha: _expanded ? 0.18 : 0.12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: _toggleExpanded,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: atmosphere.primary.withValues(alpha: 0.1),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.article_outlined,
                      color: atmosphere.primary.withValues(alpha: 0.82),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Versione continua',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: FantasyPalette.ink,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Per leggere o selezionare il prompt senza suddivisioni.',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color:
                                    FantasyPalette.ink.withValues(alpha: 0.68),
                                height: 1.4,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: duration,
                    curve: Curves.easeOutCubic,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: FantasyPalette.ink.withValues(alpha: 0.72),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ClipRect(
            child: AnimatedSize(
              duration: duration,
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: _expanded
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 1,
                            color: FantasyPalette.ink.withValues(alpha: 0.08),
                          ),
                          const SizedBox(height: 14),
                          SelectableText(
                            widget.prompt,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: FantasyPalette.ink,
                                  height: 1.62,
                                ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

class _WaxSealButton extends StatelessWidget {
  const _WaxSealButton({
    super.key,
    required this.atmosphere,
    required this.onTap,
    this.compact = false,
  });

  final CampaignAtmosphereData atmosphere;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final diameter = compact ? 88.0 : 110.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(diameter),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: diameter,
            height: diameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.28),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: atmosphere.glow.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 14),
                ),
              ],
              gradient: RadialGradient(
                colors: <Color>[
                  Color.lerp(atmosphere.primary, Colors.white, 0.1)!,
                  Color.lerp(atmosphere.primary, Colors.black, 0.08)!,
                  Color.lerp(atmosphere.primary, Colors.black, 0.28)!,
                ],
              ),
              border: Border.all(
                color: atmosphere.highlight.withValues(alpha: 0.54),
                width: 1.8,
              ),
            ),
            child: Center(
              child: Container(
                width: diameter * 0.72,
                height: diameter * 0.72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: atmosphere.highlight.withValues(alpha: 0.22),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_fire_department_rounded,
                      color: FantasyPalette.parchment,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.parchmentSeal,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: FantasyPalette.parchment,
                            letterSpacing: 1.5,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!compact) ...[
            const SizedBox(height: 10),
            Text(
              context.l10n.parchmentSealAndCopy,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionRailTile extends StatefulWidget {
  const _ActionRailTile({
    super.key,
    required this.atmosphere,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.onTapWithRect,
  }) : assert(onTap != null || onTapWithRect != null);

  final CampaignAtmosphereData atmosphere;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final ValueChanged<Rect>? onTapWithRect;

  @override
  State<_ActionRailTile> createState() => _ActionRailTileState();
}

class _ActionRailTileState extends State<_ActionRailTile> {
  final GlobalKey _tileAnchorKey = GlobalKey();
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;

  bool get _reducedMotion =>
      MediaQuery.maybeOf(context)?.disableAnimations ?? false;

  void _handleTap() {
    if (widget.onTapWithRect != null) {
      final box =
          _tileAnchorKey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        widget.onTapWithRect!(box.localToGlobal(Offset.zero) & box.size);
        return;
      }
    }
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final active = _hovered || _focused || _pressed;
    final atmosphere = widget.atmosphere;
    final palette = context.fantasy;
    final duration = _reducedMotion
        ? const Duration(milliseconds: 120)
        : const Duration(milliseconds: 180);

    return FocusableActionDetector(
      onShowFocusHighlight: (value) {
        if (_focused != value) {
          setState(() {
            _focused = value;
          });
        }
      },
      onShowHoverHighlight: (value) {
        if (_hovered != value) {
          setState(() {
            _hovered = value;
          });
        }
      },
      child: AnimatedScale(
        duration: duration,
        curve: Curves.easeOutCubic,
        scale: _pressed
            ? 0.985
            : active
                ? 1.008
                : 1.0,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _handleTap,
            onHighlightChanged: (value) {
              if (_pressed != value) {
                setState(() {
                  _pressed = value;
                });
              }
            },
            borderRadius: BorderRadius.circular(20),
            child: Ink(
              key: _tileAnchorKey,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color:
                    atmosphere.primary.withValues(alpha: active ? 0.11 : 0.06),
                border: Border.all(
                  color: atmosphere.primary
                      .withValues(alpha: active ? 0.24 : 0.12),
                ),
                boxShadow: active
                    ? <BoxShadow>[
                        BoxShadow(
                          color: atmosphere.glow.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 10),
                        ),
                      ]
                    : const <BoxShadow>[],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: duration,
                    curve: Curves.easeOutCubic,
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Color.lerp(
                        palette.canvasAlt,
                        atmosphere.primary,
                        active ? 0.42 : 0.32,
                      )!
                          .withValues(alpha: active ? 0.94 : 0.88),
                      border: Border.all(
                        color: atmosphere.highlight
                            .withValues(alpha: active ? 0.3 : 0.14),
                      ),
                    ),
                    child: Icon(
                      widget.icon,
                      color: atmosphere.highlight,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.subtitle,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color
                                        ?.withValues(alpha: 0.84),
                                    height: 1.38,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  AnimatedContainer(
                    duration: duration,
                    curve: Curves.easeOutCubic,
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.lerp(
                        palette.canvasAlt,
                        atmosphere.primary,
                        active ? 0.36 : 0.26,
                      )!
                          .withValues(alpha: active ? 0.84 : 0.76),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: atmosphere.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
