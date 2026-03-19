part of 'campaign_builder_page.dart';

extension on _CampaignBuilderPageState {
  Widget _buildEntryStage(CampaignOptions options) {
    final atmosphere = _currentAtmosphere(options);
    return EntryRoutePage(
      errorBanner: _errorMessage == null
          ? null
          : _revealed(
              delay: 0.1,
              atmosphere: atmosphere,
              child: _buildErrorBanner(_errorMessage!),
            ),
      campaignModeGrid: _revealed(
        delay: 0.14,
        atmosphere: atmosphere,
        child: _buildCampaignModeGrid(options),
      ),
      resumePanel: (_generatedPrompt != null || _hasUnsavedChanges)
          ? _revealed(
              delay: 0.2,
              atmosphere: atmosphere,
              child: _buildResumePanel(),
            )
          : null,
    );
  }

  Widget _buildCampaignModeGrid(CampaignOptions options) {
    return SectionFrame(
      title: 'Tipi di campagna',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final spacing = constraints.maxWidth < 760 ? 12.0 : 16.0;
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
                  atmosphere: meta.atmosphere,
                  title: campaignType,
                  badge: meta.badge,
                  description: meta.description,
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
            'Riprendi la sessione',
            style: _resolvedAtmosphereTheme().textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'Hai gia una bozza attiva. Torna subito al punto giusto.',
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
              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton(
                      onPressed: () => _goToForge(_forgeSection),
                      child: const Text('Riprendi la forgia'),
                    ),
                    if (_generatedPrompt != null) ...[
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () => _goToStage(_AppStage.parchment),
                        child: const Text('Apri la pergamena'),
                      ),
                    ],
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () => _goToForge(_forgeSection),
                      child: const Text('Riprendi la forgia'),
                    ),
                  ),
                  if (_generatedPrompt != null) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _goToStage(_AppStage.parchment),
                        child: const Text('Apri la pergamena'),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
