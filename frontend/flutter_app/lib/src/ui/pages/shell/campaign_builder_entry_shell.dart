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
      eyebrow: 'Archivio formati',
      title: 'Tipi di campagna',
      subtitle: 'Ogni carta porta in una flow dedicata della forgia.',
      icon: Icons.style_rounded,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 760;
          final cardWidth =
              compact ? constraints.maxWidth : (constraints.maxWidth - 16) / 2;

          return Wrap(
            spacing: 16,
            runSpacing: 16,
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
    return SectionFrame(
      eyebrow: 'Ripresa rapida',
      title: 'La tua officina e gia viva',
      subtitle:
          'Hai gia una bozza o una pergamena pronta. Riprendi dal punto giusto.',
      icon: Icons.history_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _summaryTokens()
                .map((token) => SummaryBadge(label: token))
                .toList(),
          ),
          const SizedBox(height: 16),
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
                      const SizedBox(height: 12),
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
                    const SizedBox(width: 12),
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
