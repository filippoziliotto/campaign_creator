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
            children: [
              if (_selectedPreset != null)
                SummaryBadge(
                  label: (_options?.presetNames[_selectedPreset!] ??
                          _selectedPreset!)
                      .toUpperCase(),
                  maxWidth: 180,
                  textColor: atmosphere.primary,
                ),
              ..._summaryTokens()
                  .map((token) => SummaryBadge(label: token, maxWidth: 180)),
            ],
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
            onPreviewPrompt: () {
              _showPromptPreview(atmosphere);
            },
            onGoHome: () {
              unawaited(_handleReturnHomeFromParchment());
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

  void _showPromptPreview(CampaignAtmosphereData atmosphere) {
    final prompt = _generatedPrompt;
    if (prompt == null || prompt.trim().isEmpty) {
      _showSnackBar(context.l10n.appSnackGenerateFirst);
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _PromptPreviewSheet(
          atmosphere: atmosphere,
          prompt: prompt,
        );
      },
    );
  }
}

class _PromptPreviewSheet extends StatelessWidget {
  const _PromptPreviewSheet({
    required this.atmosphere,
    required this.prompt,
  });

  final CampaignAtmosphereData atmosphere;
  final String prompt;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final maxHeight = media.size.height * 0.82;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: media.viewInsets.bottom + 16,
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Material(
              color: Colors.transparent,
              child: Container(
                key: const ValueKey('parchment-preview-sheet'),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: atmosphere.primary.withValues(alpha: 0.18),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.28),
                      blurRadius: 24,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: maxHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/background/parchment.png',
                          fit: BoxFit.cover,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Center(
                              child: Container(
                                width: 42,
                                height: 4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  color:
                                      atmosphere.primary.withValues(alpha: 0.24),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                              child: Text(
                                context.l10n.parchmentPreviewSheetTitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  0,
                                  20,
                                  18,
                                ),
                                child: SingleChildScrollView(
                                  key: const ValueKey(
                                    'parchment-preview-scroll',
                                  ),
                                  child: SelectableText(
                                    prompt,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.black,
                                          height: 1.62,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
