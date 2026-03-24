part of 'campaign_builder_page.dart';

extension on _CampaignBuilderPageState {
  Widget _buildEntryStage(CampaignOptions options) {
    final atmosphere = _currentAtmosphere(options);
    return EntryRoutePage(
      scrollController: _entryScrollController,
      hero: _revealed(
        delay: 0.1,
        atmosphere: atmosphere,
        child: _buildEntryHero(),
      ),
      errorBanner: _errorMessage == null
          ? null
          : _revealed(
              delay: 0.14,
              atmosphere: atmosphere,
              child: _buildErrorBanner(_errorMessage!),
            ),
      campaignModeGrid: _revealed(
        delay: 0.18,
        atmosphere: atmosphere,
        child: _buildCampaignModeGrid(options),
      ),
      resumePanel: (_generatedPrompt != null || _hasUnsavedChanges)
          ? _revealed(
              delay: 0.24,
              atmosphere: atmosphere,
              child: _buildResumePanel(),
            )
          : null,
    );
  }

  Widget _buildEntryHero() {
    final atmosphere = _defaultCampaignMeta.atmosphere;
    final theme = _resolvedAtmosphereTheme();
    final palette = theme.fantasy;

    return LayoutBuilder(
      key: const ValueKey<String>('entry-hero'),
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 520;
        final titleStyle = (compact
                ? theme.textTheme.headlineLarge
                : theme.textTheme.displayMedium)
            ?.copyWith(height: 0.95);

        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(18, compact ? 18 : 20, 18, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: atmosphere.primary.withValues(alpha: 0.22),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color.lerp(palette.canvasAlt, atmosphere.cardTint, 0.08)!,
                Color.lerp(palette.card, atmosphere.cardTint, 0.14)!,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEntryHeroTitle(titleStyle),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Text(
                  context.l10n.entryHeroWelcomeBody,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: palette.foreground.withValues(alpha: 0.88),
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEntryHeroTitle(TextStyle? titleStyle) {
    final title = context.l10n.entryHeroWelcomeTitle;
    if (widget.currentLocale.languageCode != 'en' ||
        title != 'Choose your Campaign') {
      return Text(title, style: titleStyle);
    }

    final resolvedStyle =
        titleStyle ?? _resolvedAtmosphereTheme().textTheme.displayMedium;
    return Semantics(
      label: title,
      child: ExcludeSemantics(
        child: RichText(
          text: TextSpan(
            style: resolvedStyle,
            children: [
              const TextSpan(text: 'Ch'),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: _buildLinkedOo(resolvedStyle),
              ),
              const TextSpan(text: 'se your Campaign'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLinkedOo(TextStyle? style) {
    final resolvedStyle =
        style ?? _resolvedAtmosphereTheme().textTheme.displayMedium;
    final fontSize = resolvedStyle?.fontSize ?? 48;
    final overlap = fontSize * 0.10;
    final letterWidth = fontSize * 0.56;
    final glyphHeight = fontSize * ((resolvedStyle?.height ?? 1.0) * 0.94);

    return SizedBox(
      key: const ValueKey<String>('entry-hero-linked-oo'),
      width: (letterWidth * 2) - overlap,
      height: glyphHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Text('o', style: resolvedStyle),
          ),
          Positioned(
            left: letterWidth - overlap,
            top: 0,
            child: Text('o', style: resolvedStyle),
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignModeGrid(CampaignOptions options) {
    return SectionFrame(
      title: context.l10n.entryCampaignTypesTitle,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final spacing = constraints.maxWidth < 760 ? 16.0 : 20.0;
          final twoColumns = constraints.maxWidth >= 640;
          final cardWidth = twoColumns
              ? (constraints.maxWidth - spacing) / 2
              : constraints.maxWidth;

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: options.campaignTypes.map((campaignType) {
              final meta =
                  _campaignTypeMeta[campaignType] ?? _defaultCampaignMeta;

              return SizedBox(
                width: cardWidth,
                child: CampaignModeCard(
                  key: ValueKey<String>('entry-campaign-card-$campaignType'),
                  atmosphere: meta.atmosphere,
                  title: campaignType,
                  badge: _localizedCampaignBadge(campaignType),
                  description: _localizedCampaignDescription(campaignType),
                  icon: meta.icon,
                  colors: meta.colors,
                  artAsset: meta.artAsset,
                  selected: _selectedCampaignType == campaignType,
                  onTap: () => _selectCampaignType(campaignType),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildResumePanel() {
    final colorScheme = _resolvedAtmosphereTheme().colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: colorScheme.surface.withValues(alpha: 0.64),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.entryResumeTitle,
            style: _resolvedAtmosphereTheme().textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            context.l10n.entryResumeSubtitle,
            style: _resolvedAtmosphereTheme().textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _summaryTokens(limit: 3)
                .map((token) => SummaryBadge(label: token, maxWidth: 180))
                .toList(),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 640;
              final compactStyle = FilledButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              );
              final resetStyle = OutlinedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              );

              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton(
                      style: compactStyle,
                      onPressed: () => _goToForge(_forgeSection),
                      child: Text(context.l10n.entryResumeForge),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      style: resetStyle,
                      onPressed: _resetDraft,
                      child: Text(context.l10n.entryResetDraft),
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      style: compactStyle,
                      onPressed: () => _goToForge(_forgeSection),
                      child: Text(context.l10n.entryResumeForge),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      style: resetStyle,
                      onPressed: _resetDraft,
                      child: Text(context.l10n.entryResetDraft),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
