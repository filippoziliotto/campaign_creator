part of 'campaign_builder_page.dart';

extension on _CampaignBuilderPageState {
  Widget _buildParchmentStage(CampaignOptions options) {
    final atmosphere = _currentAtmosphere(options);
    final isTouchPlatform = const {
      TargetPlatform.android,
      TargetPlatform.iOS,
    }.contains(defaultTargetPlatform);
    final page = ParchmentRoutePage(
      scrollController: _parchmentScrollController,
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

    if (!isTouchPlatform) {
      return page;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragEnd: _onParchmentStageSwipe,
      child: page,
    );
  }

  void _onParchmentStageSwipe(DragEndDetails details) {
    const double threshold = 300;
    final dx = details.velocity.pixelsPerSecond.dx;

    if (dx > threshold) {
      _goToForge(_ForgeSection.narrative);
    }
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
            onShare: (originRect) {
              _sharePrompt(shareOrigin: originRect);
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
