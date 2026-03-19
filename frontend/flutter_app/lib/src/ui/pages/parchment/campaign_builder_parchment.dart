import 'package:flutter/material.dart';

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
        final opacity = _reducedMotion ? 1.0 : Curves.easeOut.transform(progress);
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
                          color: widget.atmosphere.glow.withValues(alpha: glowAlpha),
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
    final words = prompt
        .split(RegExp(r'\s+'))
        .where((token) => token.trim().isNotEmpty)
        .length;

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
              Color.lerp(FantasyPalette.card, atmosphere.cardTint, 0.12)!
                  .withValues(alpha: 0.98),
              Color.lerp(FantasyPalette.cardSoft, atmosphere.cardTint, 0.2)!
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
              const SizedBox(height: 22),
            ],
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 420),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: atmosphere.primary.withValues(alpha: 0.22),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    const Color(0xFFF7ECD1),
                    Color.lerp(
                      FantasyPalette.parchmentDeep,
                      atmosphere.highlight,
                      0.18,
                    )!,
                    const Color(0xFFDABF8F),
                  ],
                ),
              ),
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
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: FantasyPalette.ink,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Una lettura strutturata del prompt finale, con capitoli richiudibili e punti chiave messi in rilievo.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: FantasyPalette.ink.withValues(alpha: 0.76),
                                ),
                          ),
                        ],
                      );

                      final seal = _WaxSealButton(
                        atmosphere: atmosphere,
                        onTap: onSealTap,
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
              Color.lerp(FantasyPalette.card, atmosphere.cardTint, 0.12)!
                  .withValues(alpha: 0.98),
              Color.lerp(FantasyPalette.cardSoft, atmosphere.cardTint, 0.2)!
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
                  label: 'Prompt copiato',
                  icon: Icons.check_circle_outline_rounded,
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
                    'Hai modificato la forgia dopo l ultima generazione. Rigenera per aggiornare il prompt copiato.',
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
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.86, end: 1.0),
                        duration: atmosphere.parchmentUnfoldDuration,
                        curve: Curves.easeOutBack,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: child,
                          );
                        },
                        child: _WaxSealButton(
                          atmosphere: atmosphere,
                          onTap: onSealTap,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'Prompt copiato',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'La pergamena e stata forgiata con successo. Usa i rituali a destra per condividerla, salvarla o aprirla in ChatGPT.',
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
  final VoidCallback onShare;
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
                'Azioni rapide',
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
          atmosphere: atmosphere,
          icon: Icons.copy_rounded,
          title: 'Copia prompt',
          subtitle: 'Invia il prompt negli appunti.',
          onTap: onCopy,
        ),
        const SizedBox(height: 10),
        _ActionRailTile(
          atmosphere: atmosphere,
          icon: Icons.ios_share_rounded,
          title: 'Condividi',
          subtitle: 'Apre il menu di condivisione.',
          onTap: onShare,
        ),
        const SizedBox(height: 10),
        _ActionRailTile(
          atmosphere: atmosphere,
          icon: Icons.open_in_new_rounded,
          title: 'Apri in ChatGPT',
          subtitle: 'Apre ChatGPT in una nuova scheda.',
          onTap: onOpenChatGpt,
        ),
        const SizedBox(height: 10),
        _ActionRailTile(
          atmosphere: atmosphere,
          icon: isCurrentDraftSaved
              ? Icons.bookmark_added_rounded
              : Icons.bookmark_border_rounded,
          title: isCurrentDraftSaved ? 'Bozza aggiornata' : 'Salva bozza',
          subtitle: savedDraftLabel ??
              'Salva il prompt localmente per dopo.',
          onTap: onSaveDraft,
        ),
      ],
    );
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
  final collapsed = body.replaceAll('\n', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: atmosphere.primary.withValues(alpha: 0.08),
        border: Border.all(
          color: atmosphere.primary.withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: atmosphere.highlight),
          const SizedBox(width: 8),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: atmosphere.primary.withValues(alpha: 0.08),
        border: Border.all(
          color: atmosphere.primary.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: atmosphere.primary.withValues(alpha: 0.16),
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
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            chapter.preview,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _PromptChapterTile extends StatelessWidget {
  const _PromptChapterTile({
    required this.atmosphere,
    required this.chapter,
  });

  final CampaignAtmosphereData atmosphere;
  final PromptChapter chapter;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: atmosphere.primary.withValues(alpha: 0.14),
          ),
          color: Colors.white.withValues(alpha: 0.12),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          iconColor: FantasyPalette.ink,
          collapsedIconColor: FantasyPalette.ink.withValues(alpha: 0.68),
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: atmosphere.primary.withValues(alpha: 0.14),
            ),
            alignment: Alignment.center,
            child: Text(
              chapter.index.toString().padLeft(2, '0'),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: FantasyPalette.ink,
                  ),
            ),
          ),
          title: Text(
            chapter.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: FantasyPalette.ink,
                ),
          ),
          subtitle: Text(
            chapter.preview,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: FantasyPalette.ink.withValues(alpha: 0.72),
                ),
          ),
          children: [
            SelectableText(
              chapter.body,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: FantasyPalette.ink,
                    height: 1.55,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromptRawTextTile extends StatelessWidget {
  const _PromptRawTextTile({
    required this.atmosphere,
    required this.prompt,
  });

  final CampaignAtmosphereData atmosphere;
  final String prompt;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: FantasyPalette.ink.withValues(alpha: 0.12),
          ),
          color: Colors.white.withValues(alpha: 0.08),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          collapsedIconColor: FantasyPalette.ink.withValues(alpha: 0.68),
          iconColor: FantasyPalette.ink,
          leading: Icon(
            Icons.article_outlined,
            color: atmosphere.primary.withValues(alpha: 0.82),
          ),
          title: Text(
            'Versione continua',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: FantasyPalette.ink,
                ),
          ),
          subtitle: Text(
            'Per leggere o selezionare il prompt senza suddivisioni.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: FantasyPalette.ink.withValues(alpha: 0.72),
                ),
          ),
          children: [
            SelectableText(
              prompt,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: FantasyPalette.ink,
                    height: 1.6,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WaxSealButton extends StatelessWidget {
  const _WaxSealButton({
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
                  color: Colors.black.withValues(alpha: 0.22),
                  blurRadius: 16,
                  offset: const Offset(0, 10),
                ),
              ],
              gradient: RadialGradient(
                colors: <Color>[
                  Color.lerp(atmosphere.primary, Colors.white, 0.08)!,
                  Color.lerp(atmosphere.primary, Colors.black, 0.16)!,
                  Color.lerp(atmosphere.primary, Colors.black, 0.34)!,
                ],
              ),
              border: Border.all(
                color: atmosphere.highlight.withValues(alpha: 0.54),
                width: 1.8,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_fire_department_rounded,
                    color: FantasyPalette.parchment,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'SIGILLA',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: FantasyPalette.parchment,
                          letterSpacing: 1.5,
                        ),
                  ),
                ],
              ),
            ),
          ),
          if (!compact) ...[
            const SizedBox(height: 10),
            Text(
              'Sigilla e copia',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionRailTile extends StatelessWidget {
  const _ActionRailTile({
    required this.atmosphere,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final CampaignAtmosphereData atmosphere;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: atmosphere.primary.withValues(alpha: 0.06),
          border: Border.all(
            color: atmosphere.primary.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: atmosphere.primary.withValues(alpha: 0.12),
              ),
              child: Icon(icon, color: atmosphere.highlight, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.arrow_forward_rounded,
              size: 18,
              color: atmosphere.primary,
            ),
          ],
        ),
      ),
    );
  }
}
