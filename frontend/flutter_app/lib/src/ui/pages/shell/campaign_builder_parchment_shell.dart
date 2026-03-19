part of 'campaign_builder_page.dart';

extension on _CampaignBuilderPageState {
  Widget _buildParchmentStage(CampaignOptions options) {
    final atmosphere = _currentAtmosphere(options);
    return ParchmentRoutePage(
      atmosphere: atmosphere,
      hero: _revealed(
        delay: 0.02,
        atmosphere: atmosphere,
        child: _buildParchmentHero(),
      ),
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

  Widget _buildParchmentHero() {
    final atmosphere = _currentAtmosphere();
    return HeroFrame(
      atmosphere: atmosphere,
      eyebrow: 'Pergamena finale',
      title: 'Il prompt e stato forgiato',
      badges: <Widget>[
        SummaryBadge(label: atmosphere.label),
        SummaryBadge(label: _forgeStatusLabel()),
        SummaryBadge(label: _selectedCampaignType ?? 'Formato libero'),
        SummaryBadge(label: _currentSettingLabel()),
      ],
      trailing: SizedBox(
        width: 240,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              onPressed: _sealCurrentParchment,
              icon: const Icon(Icons.approval_rounded),
              label: const Text('Sigilla pergamena'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _goToForge(_ForgeSection.narrative),
              icon: const Icon(Icons.edit_rounded),
              label: const Text('Riapri la forgia'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _goToStage(_AppStage.entry),
              icon: const Icon(Icons.home_rounded),
              label: const Text('Nuova leggenda'),
            ),
          ],
        ),
      ),
      footer: LoreCallout(
        icon: _hasUnsavedChanges
            ? Icons.refresh_rounded
            : Icons.check_circle_outline,
        text: _hasUnsavedChanges
            ? 'Hai modificato alcuni campi dopo la generazione. La pergamena visibile non e aggiornata.'
            : 'La pergamena attuale e allineata con l ultima configurazione della forgia.',
      ),
    );
  }

  Widget _buildParchmentSidebar() {
    final atmosphere = _currentAtmosphere();
    return Column(
      children: [
        SectionFrame(
          eyebrow: 'Stato finale',
          title: 'Compendio della leggenda',
          subtitle: 'Le scelte attive che hanno definito questa pergamena.',
          icon: Icons.shield_moon_rounded,
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
              LoreCallout(
                icon: Icons.menu_book_rounded,
                text: _currentTwistLabel(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
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
    );
  }
}
