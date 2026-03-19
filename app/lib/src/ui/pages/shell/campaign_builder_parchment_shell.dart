part of 'campaign_builder_page.dart';

extension on _CampaignBuilderPageState {
  Widget _buildParchmentStage(CampaignOptions options) {
    final atmosphere = _currentAtmosphere(options);
    return ParchmentRoutePage(
      atmosphere: atmosphere,
      errorBanner: _errorMessage == null
          ? null
          : _revealed(
              delay: 0.1,
              atmosphere: atmosphere,
              child: _buildErrorBanner(_errorMessage!),
            ),
      sidebar: _revealed(
        delay: 0.14,
        atmosphere: atmosphere,
        child: _buildParchmentSidebar(),
      ),
    );
  }

  Widget _buildParchmentSidebar() {
    final atmosphere = _currentAtmosphere();
    return SectionFrame(
      title: context.l10n.parchmentReadyTitle,
      subtitle: _hasUnsavedChanges
          ? context.l10n.parchmentReadySubtitleStale
          : context.l10n.parchmentReadySubtitleAligned,
      density: FrameDensity.featured,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _summaryTokens(limit: 4)
                .map((token) => SummaryBadge(label: token, maxWidth: 180))
                .toList(),
          ),
          const SizedBox(height: 12),
          LoreCallout(
            icon: _hasUnsavedChanges
                ? Icons.refresh_rounded
                : Icons.check_circle_outline_rounded,
            text: _currentTwistLabel(),
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: _resolvedAtmosphereTheme().colorScheme.outline.withValues(
                  alpha: 0.16,
                ),
          ),
          const SizedBox(height: 16),
          ParchmentActionRail(
            atmosphere: atmosphere,
            onCopy: () {
              _copyPrompt();
            },
            onShare: () {
              _sharePrompt();
            },
            onOpenChatGpt: () {
              _openPromptInChatGpt();
            },
            onSaveDraft: () {
              _savePromptDraft();
            },
            onWaxSealTap: () {
              _sealCurrentParchment();
            },
            isCurrentDraftSaved: _isCurrentDraftSaved(),
            savedDraftLabel: _savedDraftLabel(),
          ),
        ],
      ),
    );
  }
}
