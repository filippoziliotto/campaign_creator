part of 'campaign_builder_page.dart';

extension on _CampaignBuilderPageState {
  Widget _buildForgeStage(CampaignOptions options) {
    final atmosphere = _currentAtmosphere(options);
    final isTouchPlatform = const {
      TargetPlatform.android,
      TargetPlatform.iOS,
    }.contains(defaultTargetPlatform);
    final activeSection = _revealed(
      delay: 0.18,
      atmosphere: atmosphere,
      child: _buildActiveForgeSection(options),
    );

    return ForgeRoutePage(
      scrollController: _forgeScrollController,
      errorBanner: _errorMessage == null
          ? null
          : _revealed(
              delay: 0.1,
              atmosphere: atmosphere,
              child: _buildErrorBanner(_errorMessage!),
            ),
      sectionRibbon: _revealed(
        delay: 0.12,
        atmosphere: atmosphere,
        child: _buildForgeSectionRibbon(),
      ),
      activeSection: isTouchPlatform
          ? GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragEnd: _onForgeSectionSwipe,
              child: activeSection,
            )
          : activeSection,
      controlPanel: _revealed(
        delay: 0.22,
        atmosphere: atmosphere,
        child: _buildForgeControlPanel(),
      ),
    );
  }

  void _onForgeSectionSwipe(DragEndDetails details) {
    const double threshold = 300;
    final dx = details.velocity.pixelsPerSecond.dx;
    final sections = _ForgeSection.values;
    final currentIndex = _forgeSectionIndex(_forgeSection);
    final lastIndex = sections.length - 1;

    if (dx < -threshold && currentIndex < lastIndex) {
      _applyShellState(() {
        _setForgeSection(sections[currentIndex + 1]);
      });
      return;
    }

    if (dx < -threshold && currentIndex == lastIndex) {
      _goToStage(_AppStage.parchment);
      return;
    }

    if (dx > threshold && currentIndex == 0) {
      _goToStage(_AppStage.entry);
      return;
    }

    if (dx > threshold && currentIndex > 0) {
      _applyShellState(() {
        _setForgeSection(sections[currentIndex - 1]);
      });
    }
  }

  Widget _buildForgeSectionRibbon() {
    final theme = _resolvedAtmosphereTheme();

    return Theme(
      data: theme,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompactRibbon = constraints.maxWidth < 420;
          final iconSize = isCompactRibbon ? 16.0 : 18.0;
          final segments = _ForgeSection.values.map((section) {
            final index = _ForgeSection.values.indexOf(section);
            final completed =
                index < _ForgeSection.values.indexOf(_forgeSection);
            return ButtonSegment<_ForgeSection>(
              value: section,
              label: Text(
                _forgeSectionLabel(section),
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
              icon: completed
                  ? Icon(Icons.check_circle_rounded, size: iconSize)
                  : Icon(_forgeSectionIcon(section), size: iconSize),
            );
          }).toList();
          final button = SegmentedButton<_ForgeSection>(
            key: const ValueKey<String>('forge-section-ribbon'),
            showSelectedIcon: false,
            segments: segments,
            style: ButtonStyle(
              visualDensity: isCompactRibbon
                  ? const VisualDensity(horizontal: -3, vertical: -2)
                  : VisualDensity.compact,
              padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(
                  horizontal: isCompactRibbon ? 8 : 12,
                  vertical: isCompactRibbon ? 6 : 10,
                ),
              ),
              textStyle: WidgetStatePropertyAll<TextStyle?>(
                theme.textTheme.labelMedium?.copyWith(
                  fontSize: isCompactRibbon ? 11.5 : null,
                  letterSpacing: isCompactRibbon ? 0.2 : null,
                ),
              ),
            ),
            selected: {_forgeSection},
            onSelectionChanged: (selection) {
              _selectForgeSectionFromRibbon(selection.first);
            },
          );

          if (constraints.maxWidth < 520) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: button,
              ),
            );
          }

          return button;
        },
      ),
    );
  }

  IconData _forgeSectionIcon(_ForgeSection section) {
    switch (section) {
      case _ForgeSection.world:
        return Icons.public_rounded;
      case _ForgeSection.party:
        return Icons.groups_rounded;
      case _ForgeSection.narrative:
        return Icons.auto_stories_rounded;
    }
  }

  Widget _buildActiveForgeSection(CampaignOptions options) {
    final atmosphere = _currentAtmosphere(options);
    final child = switch (_forgeSection) {
      _ForgeSection.world => _buildCampaignSection(options),
      _ForgeSection.party => _buildPartySection(options),
      _ForgeSection.narrative => _buildNarrativeSection(),
    };

    return PageTransitionSwitcher(
      duration: atmosphere.sectionTransitionDuration,
      reverse: _forgeTransitionReverse,
      child: KeyedSubtree(
        key: ValueKey<String>('forge-section-${_forgeSection.name}'),
        child: child,
      ),
      transitionBuilder: (
        Widget child,
        Animation<double> primaryAnimation,
        Animation<double> secondaryAnimation,
      ) {
        return buildCampaignSharedAxisTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: atmosphere.sectionTransitionType,
          child: child,
        );
      },
    );
  }

  Widget _buildForgeControlPanel() {
    final atmosphere = _currentAtmosphere();
    final primaryActionEnabled = _isForgePrimaryActionEnabled();
    final parchmentReady = (_generatedPrompt ?? '').trim().isNotEmpty;

    return ForgeActionStrip(
      atmosphere: atmosphere,
      readinessHint: _forgeReadinessHint(),
      isPrimaryEnabled: primaryActionEnabled,
      isGenerating: _isGenerating,
      primaryLabel: _isGenerating
          ? context.l10n.forgeButtonForging
          : _nextForgeActionLabel(),
      primaryIcon: _forgeSection == _ForgeSection.narrative
          ? Icons.auto_awesome_rounded
          : Icons.arrow_forward_rounded,
      onRetreat: _retreatForge,
      onAdvance: _advanceForge,
      parchmentReady: parchmentReady,
      hasUnsavedChanges: _hasUnsavedChanges,
      onOpenParchment: () => _goToStage(_AppStage.parchment),
      savedDraftLabel: _savedDraftLabel(),
    );
  }

  String _forgeReadinessHint() {
    switch (_forgeSection) {
      case _ForgeSection.world:
        return _primaryActionHint(
          ready: _canAdvanceWorldSection(),
          readyText: context.l10n.forgeReadinessWorldReady,
          pendingText: context.l10n.forgeReadinessWorldPending,
        );
      case _ForgeSection.party:
        return _primaryActionHint(
          ready: _canAdvancePartySection(),
          readyText: context.l10n.forgeReadinessPartyReady,
          pendingText: context.l10n.forgeReadinessPartyPending,
        );
      case _ForgeSection.narrative:
        return _primaryActionHint(
          ready: _canForgeNarrativeSection(),
          readyText: context.l10n.forgeReadinessNarrativeReady,
          pendingText: context.l10n.forgeReadinessNarrativePending,
        );
    }
  }

  String _primaryActionHint({
    required bool ready,
    required String readyText,
    required String pendingText,
  }) {
    return ready ? readyText : pendingText;
  }

  Widget _buildCampaignSection(CampaignOptions options) {
    final presets = _availablePresetsForCampaignType(options);
    final effectiveSelectedPreset =
        presets.contains(_selectedPreset) ? _selectedPreset : null;
    final settingDescription =
        options.settingDescriptions[_selectedSetting ?? ''];
    final presetDescription = effectiveSelectedPreset == null
        ? null
        : options.presetDescriptions[effectiveSelectedPreset];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionFrame(
          title: context.l10n.forgeWorldSectionTitle,
          subtitle: context.l10n.forgeWorldSectionSubtitle,
          density: FrameDensity.featured,
          emphasis: PanelEmphasis.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWorldFoundationPanel(options, settingDescription),
              const SizedBox(height: 18),
              _buildCreativeDirectionPanel(options),
              const SizedBox(height: 18),
              _buildWorldTwistPanel(options),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SectionFrame(
          title: context.l10n.forgePresetSectionTitle,
          subtitle: context.l10n.forgePresetSectionSubtitle,
          density: FrameDensity.featured,
          emphasis: PanelEmphasis.secondary,
          child: _buildPresetsPanel(
            presets,
            effectiveSelectedPreset,
            presetDescription,
            options.presetNames,
            effectiveSelectedPreset != null &&
                effectiveSelectedPreset == _appliedPreset,
          ),
        ),
      ],
    );
  }

  Widget _buildWorldFoundationPanel(
    CampaignOptions options,
    String? settingDescription,
  ) {
    return ControlRoomPanel(
      label: context.l10n.forgeFoundationLabel,
      title: context.l10n.forgeFoundationTitle,
      subtitle: context.l10n.forgeFoundationSubtitle,
      icon: Icons.public_rounded,
      density: FrameDensity.featured,
      emphasis: PanelEmphasis.primary,
      showDivider: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPickerSelector(
            title: context.l10n.forgeFoundationTitle,
            label: context.l10n.forgeSettingLabel,
            value: _selectedSetting,
            options: options.settings,
            keyPrefix: 'setting-selector',
            uppercaseText: true,
            premiumOptionIds: options.settings.length >= 2
                ? {
                    options.settings[options.settings.length - 2],
                    options.settings.last,
                  }
                : options.settings.isNotEmpty
                    ? {options.settings.last}
                    : const {},
            premiumHighlightColor: _currentAtmosphere(options).glow,
            useWheelPicker: true,
            showCustomOption: true,
            isCustomOptionLocked: !_isPremiumUnlocked,
            onCustomOptionTap: () => _showCustomEntryDialog(
              title: 'Custom Setting',
              hint: context.l10n.forgeCustomSettingHint,
              onAdd: (value) => _markDirty(() {
                _selectedSetting = value;
                _scrollForgeToRevealCreativePanel();
              }),
            ),
            onChanged: (value) {
              _markDirty(() {
                _selectedSetting = value;
              });
              if (value != null) _scrollForgeToRevealCreativePanel();
            },
          ),
          if (settingDescription != null) ...[
            const SizedBox(height: 12),
            LoreCallout(
              icon: Icons.travel_explore_rounded,
              text: settingDescription,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPresetsPanel(
    List<String> presets,
    String? effectiveSelectedPreset,
    String? presetDescription,
    Map<String, String> presetNames,
    bool isApplied,
  ) {
    return ControlRoomPanel(
      label: context.l10n.forgePresetPanelLabel,
      title: context.l10n.forgePresetPanelTitle,
      icon: Icons.bolt_rounded,
      density: FrameDensity.featured,
      emphasis: PanelEmphasis.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Builder(
            builder: (context) {
              final presetSelector = _buildPickerSelector(
                title: context.l10n.forgePresetPanelTitle,
                label: context.l10n.forgeQuickPresetLabel,
                value: effectiveSelectedPreset,
                options: presets,
                labels: presetNames,
                keyPrefix: 'preset-selector',
                uppercaseText: true,
                emptyText: context.l10n.forgeNoPresetSelected,
                defaultToFirstOption: false,
                onChanged: (value) {
                  _markDirty(() {
                    _selectedPreset = value;
                  });
                },
              );

              return LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 520;
                  if (compact) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        presetSelector,
                        if (!isApplied) ...[
                          const SizedBox(height: 12),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                            ),
                            onPressed: effectiveSelectedPreset == null
                                ? null
                                : _applyPreset,
                            child: Text(context.l10n.forgeApplyPreset),
                          ),
                        ],
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: presetSelector),
                      if (!isApplied) ...[
                        const SizedBox(width: 12),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                          ),
                          onPressed: effectiveSelectedPreset == null
                              ? null
                              : _applyPreset,
                          child: Text(context.l10n.forgeApply),
                        ),
                      ],
                    ],
                  );
                },
              );
            },
          ),
          if (presetDescription != null) ...[
            const SizedBox(height: 12),
            LoreCallout(
              icon: Icons.local_library_outlined,
              text: presetDescription,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWorldTwistPanel(CampaignOptions options) {
    return ControlRoomPanel(
      title: context.l10n.forgeTwistTitle,
      emphasis: PanelEmphasis.tertiary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPickerSelector(
            title: context.l10n.forgeTwistTitle,
            label: context.l10n.forgeTwistLabel,
            value: _selectedTwist,
            options: options.twists,
            keyPrefix: 'twist-selector',
            emptyText: context.l10n.appTwistPending,
            onChanged: (value) {
              _markDirty(() {
                _selectedTwist = value;
              });
            },
          ),
          const SizedBox(height: 14),
          _buildLoreTextField(
            controller: _customTwistController,
            label: context.l10n.forgeCustomTwistLabel,
            hintText: context.l10n.forgeCustomTwistHint,
            minLines: 2,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildPickerSelector({
    required String title,
    required String label,
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    required String keyPrefix,
    Map<String, String> labels = const {},
    String? emptyText,
    bool uppercaseText = false,
    bool defaultToFirstOption = true,
    Set<String> premiumOptionIds = const {},
    Color? premiumHighlightColor,
    bool showCustomOption = false,
    bool isCustomOptionLocked = false,
    VoidCallback? onCustomOptionTap,
    bool useWheelPicker = false,
  }) {
    // If the value is not a known preset, it's a custom-entered value — show as-is.
    final isCustomValue =
        value != null && value.isNotEmpty && !options.contains(value);
    final normalizedValue = isCustomValue
        ? value
        : options.contains(value)
            ? value
            : (defaultToFirstOption && options.isNotEmpty
                ? options.first
                : null);
    final hasVisibleSummary = normalizedValue != null || emptyText != null;
    String displayText(String raw) =>
        uppercaseText ? raw.toUpperCase() : raw;
    final summary = normalizedValue == null
        ? (emptyText ?? label)
        : displayText(labels[normalizedValue] ?? normalizedValue);

    return InkWell(
      key: ValueKey<String>('$keyPrefix-field'),
      onTap: options.isEmpty
          ? null
          : () async {
              FocusScope.of(context).unfocus();

              // Resolve premium access state if any options are gated.
              bool premiumUnlocked = premiumOptionIds.isEmpty;
              if (premiumOptionIds.isNotEmpty) {
                final prefs = await _resolvePreferences();
                if (prefs != null) {
                  final state = PremiumAccessService.checkState(
                    prefs,
                    MonetizationPrefs(),
                  );
                  premiumUnlocked = state != PremiumAccessState.locked;
                }
              }

              final selected = useWheelPicker
                  ? await _showWheelOptionPicker(
                      keyPrefix: keyPrefix,
                      title: title,
                      options: options,
                      currentValue: normalizedValue,
                      premiumOptionIds: premiumOptionIds,
                      isPremiumUnlocked: premiumUnlocked,
                      crownColor: premiumHighlightColor ??
                          _resolvedAtmosphereTheme().colorScheme.tertiary,
                      showCustomOption: showCustomOption,
                      isCustomOptionLocked: !premiumUnlocked,
                      onCustomOptionTap: onCustomOptionTap,
                    )
                  : await _showOptionPicker(
                      keyPrefix: keyPrefix,
                      title: title,
                      label: label,
                      currentValue: normalizedValue,
                      options: options,
                      labels: labels,
                      uppercaseText: uppercaseText,
                      premiumOptionIds: premiumOptionIds,
                      isPremiumUnlocked: premiumUnlocked,
                      premiumHighlightColor: premiumHighlightColor,
                      showCustomOption: showCustomOption,
                      isCustomOptionLocked: isCustomOptionLocked,
                      onCustomOptionTap: onCustomOptionTap,
                    );
              if (selected != null) {
                onChanged(selected);
              }
            },
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        isEmpty: !hasVisibleSummary,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.unfold_more_rounded),
        ),
        child: Text(
          summary,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Future<String?> _showOptionPicker({
    required String keyPrefix,
    required String title,
    required String label,
    required String? currentValue,
    required List<String> options,
    Map<String, String> labels = const {},
    bool uppercaseText = false,
    Set<String> premiumOptionIds = const {},
    bool isPremiumUnlocked = true,
    Color? premiumHighlightColor,
    bool showCustomOption = false,
    bool isCustomOptionLocked = false,
    VoidCallback? onCustomOptionTap,
  }) {
    final theme = _resolvedAtmosphereTheme();
    // Capture the state's stable BuildContext before entering any builder
    // so async callbacks inside nested modals always have a valid context.
    final stableContext = context;

    return showModalBottomSheet<String>(
      context: stableContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final colorScheme = theme.colorScheme;
        final bottomInset = MediaQuery.viewInsetsOf(sheetContext).bottom;
        final maxHeight = MediaQuery.sizeOf(sheetContext).height * 0.72;

        return Theme(
          data: theme,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(12, 12, 12, bottomInset + 12),
              child: Container(
                key: ValueKey<String>('$keyPrefix-sheet'),
                constraints: BoxConstraints(maxHeight: maxHeight),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.18),
                  ),
                  color: colorScheme.surface,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                        width: 42,
                        height: 5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: colorScheme.outlineVariant,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: theme.textTheme.titleLarge),
                          const SizedBox(height: 4),
                          Text(
                            label,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        itemCount:
                            options.length + (showCustomOption ? 1 : 0),
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          color: colorScheme.outline.withValues(alpha: 0.12),
                        ),
                        itemBuilder: (_, index) {
                          // "Custom…" tile at the end
                          if (showCustomOption && index == options.length) {
                            final crownColor =
                                premiumHighlightColor ?? colorScheme.tertiary;
                            return ListTile(
                              key: ValueKey<String>('$keyPrefix-option-custom'),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              title: Text(
                                'CUSTOM',
                                style: TextStyle(color: crownColor),
                              ),
                              trailing: PremiumCrownBadge(
                                highlightColor: crownColor,
                                size: 18,
                              ),
                              onTap: isCustomOptionLocked
                                  ? () {
                                      Navigator.of(sheetContext).pop();
                                      showModalBottomSheet<void>(
                                        context: stableContext,
                                        backgroundColor: Colors.transparent,
                                        builder: (_) => PremiumUnlockPrompt(
                                          highlightColor: crownColor,
                                          onWatchAd: () async {
                                            Navigator.pop(stableContext);
                                            final prefs =
                                                await _resolvePreferences();
                                            if (prefs == null) return;
                                            await PremiumAccessService
                                                .grantTemporaryAccess(
                                              prefs,
                                              MonetizationPrefs(),
                                            );
                                            if (mounted) {
                                              _applyShellState(() {
                                                _premiumTemporaryUnlockGrantedAt =
                                                    DateTime.now();
                                              });
                                            }
                                          },
                                          onGoAdFree: () {
                                            Navigator.pop(stableContext);
                                            _handleGoAdFree();
                                          },
                                        ),
                                      );
                                    }
                                  : () {
                                      Navigator.of(sheetContext).pop();
                                      onCustomOptionTap?.call();
                                    },
                            );
                          }

                          final option = options[index];
                          final isSelected = option == currentValue;
                          final isPremium = premiumOptionIds.contains(option);
                          final isLocked = isPremium && !isPremiumUnlocked;
                          final displayLabel = uppercaseText
                              ? (labels[option] ?? option).toUpperCase()
                              : (labels[option] ?? option);
                          final crownColor =
                              premiumHighlightColor ?? colorScheme.tertiary;

                          // Build trailing: crown badge and/or checkmark.
                          Widget? trailing;
                          if (isSelected && isPremium) {
                            trailing = Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                PremiumCrownBadge(
                                  highlightColor: crownColor,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: colorScheme.primary,
                                ),
                              ],
                            );
                          } else if (isSelected) {
                            trailing = Icon(
                              Icons.check_circle_rounded,
                              color: colorScheme.primary,
                            );
                          } else if (isPremium) {
                            trailing = PremiumCrownBadge(
                              highlightColor: crownColor,
                              size: 18,
                            );
                          }

                          return ListTile(
                            key: ValueKey<String>(
                              '$keyPrefix-option-$index',
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            title: Text(
                              displayLabel,
                              style: isPremium
                                  ? TextStyle(color: crownColor)
                                  : null,
                            ),
                            trailing: trailing,
                            onTap: isLocked
                                ? () {
                                    // Close the picker without a selection,
                                    // then present the premium unlock prompt.
                                    Navigator.of(sheetContext).pop();
                                    showModalBottomSheet<void>(
                                      context: stableContext,
                                      backgroundColor: Colors.transparent,
                                      builder: (_) => PremiumUnlockPrompt(
                                        highlightColor: crownColor,
                                        onWatchAd: () async {
                                          Navigator.pop(stableContext);
                                          // TODO: replace with a real rewarded
                                          // ad once a rewarded ad service is
                                          // wired up. For now this grants
                                          // access directly for testing.
                                          final prefs =
                                              await _resolvePreferences();
                                          if (prefs == null) return;
                                          await PremiumAccessService
                                              .grantTemporaryAccess(
                                            prefs,
                                            MonetizationPrefs(),
                                          );
                                          if (mounted) {
                                            _applyShellState(() {
                                              _premiumTemporaryUnlockGrantedAt =
                                                  DateTime.now();
                                            });
                                          }
                                        },
                                        onGoAdFree: () {
                                          Navigator.pop(stableContext);
                                          _handleGoAdFree();
                                        },
                                      ),
                                    );
                                  }
                                : () => Navigator.of(sheetContext).pop(option),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<String?> _showWheelOptionPicker({
    required String keyPrefix,
    required String title,
    required List<String> options,
    required String? currentValue,
    required Set<String> premiumOptionIds,
    required bool isPremiumUnlocked,
    required Color crownColor,
    bool showCustomOption = false,
    bool isCustomOptionLocked = false,
    VoidCallback? onCustomOptionTap,
  }) {
    const customSentinel = '__custom__';
    final allOptions = [
      ...options,
      if (showCustomOption) customSentinel,
    ];

    final initialIndex = currentValue != null
        ? allOptions.indexOf(currentValue).clamp(0, allOptions.length - 1)
        : 0;

    final stableContext = context;
    final theme = _resolvedAtmosphereTheme();

    return showModalBottomSheet<String>(
      context: stableContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final colorScheme = theme.colorScheme;
        final scrollController =
            FixedExtentScrollController(initialItem: initialIndex);
        var selectedIndex = initialIndex;

        return Theme(
          data: theme,
          child: StatefulBuilder(
            builder: (_, setState) {
              final selectedOption = allOptions[selectedIndex];
              final isCustomSelected = selectedOption == customSentinel;
              final isPremiumSelected = isCustomSelected ||
                  premiumOptionIds.contains(selectedOption);
              final isLockedSelected = isPremiumSelected && !isPremiumUnlocked ||
                  (isCustomSelected && isCustomOptionLocked);

              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.18),
                      ),
                      color: colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        Center(
                          child: Container(
                            width: 42,
                            height: 5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              color: colorScheme.outlineVariant,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
                          child:
                              Text(title, style: theme.textTheme.titleLarge),
                        ),
                        SizedBox(
                          height: 320,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ListWheelScrollView(
                                controller: scrollController,
                                itemExtent: 52,
                                perspective: 0.004,
                                diameterRatio: 2.8,
                                physics: const FixedExtentScrollPhysics(),
                                onSelectedItemChanged: (i) =>
                                    setState(() => selectedIndex = i),
                                children: allOptions.map((option) {
                                  final isCustom = option == customSentinel;
                                  final isPremium = isCustom ||
                                      premiumOptionIds.contains(option);
                                  final displayLabel =
                                      isCustom ? 'CUSTOM' : option.toUpperCase();
                                  return Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          displayLabel,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                            color: isPremium
                                                ? crownColor
                                                : colorScheme.onSurface,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.8,
                                          ),
                                        ),
                                        if (isPremium) ...[
                                          const SizedBox(width: 8),
                                          FaIcon(
                                            FontAwesomeIcons.crown,
                                            size: 12,
                                            color: crownColor,
                                          ),
                                        ],
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                              // Top fade
                              IgnorePointer(
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          colorScheme.surface,
                                          colorScheme.surface
                                              .withValues(alpha: 0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Bottom fade
                              IgnorePointer(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          colorScheme.surface,
                                          colorScheme.surface
                                              .withValues(alpha: 0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Center selection band
                              IgnorePointer(
                                child: Center(
                                  child: Container(
                                    height: 52,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 24),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color:
                                              crownColor.withValues(alpha: 0.4),
                                        ),
                                        bottom: BorderSide(
                                          color:
                                              crownColor.withValues(alpha: 0.4),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                          child: SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () {
                                if (isLockedSelected) {
                                  Navigator.of(sheetContext).pop();
                                  showModalBottomSheet<void>(
                                    context: stableContext,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) => PremiumUnlockPrompt(
                                      highlightColor: crownColor,
                                      onWatchAd: () async {
                                        Navigator.pop(stableContext);
                                        final prefs =
                                            await _resolvePreferences();
                                        if (prefs == null) return;
                                        await PremiumAccessService
                                            .grantTemporaryAccess(
                                          prefs,
                                          MonetizationPrefs(),
                                        );
                                        if (mounted) {
                                          _applyShellState(() {
                                            _premiumTemporaryUnlockGrantedAt =
                                                DateTime.now();
                                          });
                                        }
                                      },
                                      onGoAdFree: () {
                                        Navigator.pop(stableContext);
                                        _handleGoAdFree();
                                      },
                                    ),
                                  );
                                } else if (isCustomSelected) {
                                  Navigator.of(sheetContext).pop();
                                  onCustomOptionTap?.call();
                                } else {
                                  Navigator.of(sheetContext).pop(selectedOption);
                                }
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: isLockedSelected
                                    ? colorScheme.surfaceContainerHighest
                                    : crownColor.withValues(alpha: 0.9),
                                foregroundColor: isLockedSelected
                                    ? colorScheme.onSurfaceVariant
                                    : FantasyPalette.parchment,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                isLockedSelected
                                    ? 'Unlock Premium'
                                    : isCustomSelected
                                        ? 'Enter Custom'
                                        : 'Select',
                                style: theme.textTheme.labelLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showPremiumUnlockForChip(Color crownColor) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => PremiumUnlockPrompt(
        highlightColor: crownColor,
        onWatchAd: () async {
          Navigator.pop(context);
          // TODO: replace with a real rewarded ad once a rewarded ad service
          // is wired up. For now this grants access directly for testing.
          final prefs = await _resolvePreferences();
          if (prefs == null) return;
          await PremiumAccessService.grantTemporaryAccess(
            prefs,
            MonetizationPrefs(),
          );
          if (mounted) {
            _applyShellState(() {
              _premiumTemporaryUnlockGrantedAt = DateTime.now();
            });
          }
        },
        onGoAdFree: () {
          Navigator.pop(context);
          _handleGoAdFree();
        },
      ),
    );
  }

  Widget _buildCreativeDirectionPanel(CampaignOptions options) {
    return ControlRoomPanel(
      title: context.l10n.forgeCreativeTitle,
      emphasis: PanelEmphasis.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.forgeThemesTitle,
            style: _resolvedAtmosphereTheme().textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          _buildThemesChipSection(options),
          const SizedBox(height: 18),
          Text(
            context.l10n.forgeToneTitle,
            style: _resolvedAtmosphereTheme().textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          _buildTonesChipSection(options),
          const SizedBox(height: 18),
          Text(
            context.l10n.forgeStyleTitle,
            style: _resolvedAtmosphereTheme().textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          _buildStylesChipSection(options),
        ],
      ),
    );
  }

  Widget _buildPartySection(CampaignOptions options) {
    return SectionFrame(
      title: context.l10n.forgePartySectionTitle,
      subtitle: context.l10n.forgePartySectionSubtitle,
      density: FrameDensity.featured,
      emphasis: PanelEmphasis.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final pairedWidth = constraints.maxWidth >= 920
                  ? (constraints.maxWidth - 18) / 2
                  : constraints.maxWidth;
              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: [
                  SizedBox(
                    width: pairedWidth,
                    child: _buildPartyMetricsPanel(),
                  ),
                  SizedBox(
                    width: pairedWidth,
                    child: _buildPartyArchetypesPanel(options),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          ControlRoomPanel(
            title: context.l10n.forgePartyInfoTitle,
            emphasis: PanelEmphasis.tertiary,
            child: Column(
              children: [
                _buildLoreTextField(
                  controller: _characterNotesController,
                  label: context.l10n.forgeCharacterNotesLabel,
                  hintText: context.l10n.forgeCharacterNotesHint,
                  minLines: 3,
                  maxLines: 5,
                ),
                const SizedBox(height: 14),
                _buildLoreTextField(
                  controller: _constraintsController,
                  label: context.l10n.forgeConstraintsLabel,
                  hintText: context.l10n.forgeConstraintsHint,
                  minLines: 2,
                  maxLines: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartyMetricsPanel() {
    return ControlRoomPanel(
      label: context.l10n.forgeScaleLabel,
      title: context.l10n.forgeScaleTitle,
      icon: Icons.tune_rounded,
      density: FrameDensity.featured,
      emphasis: PanelEmphasis.primary,
      showDivider: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.forgePartyLevel(_partyLevel),
            style: _resolvedAtmosphereTheme().textTheme.titleMedium,
          ),
          Slider(
            value: _partyLevel.toDouble(),
            min: 1,
            max: 20,
            divisions: 19,
            label: '$_partyLevel',
            onChanged: (value) {
              _markDirty(() {
                _partyLevel = value.round();
              });
            },
          ),
          const SizedBox(height: 10),
          Text(
            context.l10n.forgePartySize(_partySize),
            style: _resolvedAtmosphereTheme().textTheme.titleMedium,
          ),
          Slider(
            value: _partySize.toDouble(),
            min: 1,
            max: 8,
            divisions: 7,
            label: '$_partySize',
            onChanged: (value) {
              _markDirty(() {
                _partySize = value.round();
                _trimArchetypesToPartySize();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPartyArchetypesPanel(CampaignOptions options) {
    return ControlRoomPanel(
      title: context.l10n.forgePartyArchetypesTitle,
      subtitle: context.l10n.forgePartyArchetypesSubtitle(_partySize),
      emphasis: PanelEmphasis.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChipWrap(
            options.partyArchetypes,
            _selectedArchetypes,
            (value, selected) {
              _markDirty(() {
                if (selected) {
                  if (_selectedArchetypes.length < _partySize) {
                    _selectedArchetypes.add(value);
                  }
                } else {
                  _selectedArchetypes.remove(value);
                }
              });
            },
            premiumOptionIds: options.partyArchetypes.isNotEmpty
                ? {options.partyArchetypes.last}
                : const {},
            premiumCrownColor: _currentAtmosphere().glow,
          ),
          if (_selectedArchetypes.length >= _partySize) ...[
            const SizedBox(height: 12),
            LoreCallout(
              icon: Icons.info_outline_rounded,
              text: context.l10n.forgePartyArchetypesMaxReached,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNarrativeSection() {
    return SectionFrame(
      eyebrow: context.l10n.commonOptional,
      title: context.l10n.forgeNarrativeSectionTitle,
      subtitle: context.l10n.forgeNarrativeSectionSubtitle,
      density: FrameDensity.featured,
      emphasis: PanelEmphasis.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ControlRoomPanel(
            title: context.l10n.forgeNarrativePanelTitle,
            icon: Icons.hub_rounded,
            density: FrameDensity.featured,
            emphasis: PanelEmphasis.primary,
            showDivider: true,
            child: Column(
              children: [
                _buildLoreTextField(
                  controller: _narrativeHooksController,
                  label: context.l10n.forgeNarrativeHooksLabel,
                  hintText: context.l10n.forgeNarrativeHooksHint,
                  minLines: 3,
                  maxLines: 5,
                ),
                const SizedBox(height: 14),
                _buildLoreTextField(
                  controller: _factionsController,
                  label: context.l10n.forgeFactionsLabel,
                  hintText: context.l10n.forgeFactionsHint,
                  minLines: 2,
                  maxLines: 4,
                ),
                const SizedBox(height: 14),
                _buildLoreTextField(
                  controller: _npcFocusController,
                  label: context.l10n.forgeNpcFocusLabel,
                  hintText: context.l10n.forgeNpcFocusHint,
                  minLines: 2,
                  maxLines: 4,
                ),
                const SizedBox(height: 14),
                _buildLoreTextField(
                  controller: _encounterFocusController,
                  label: context.l10n.forgeEncounterFocusLabel,
                  hintText: context.l10n.forgeEncounterFocusHint,
                  minLines: 2,
                  maxLines: 4,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ControlRoomPanel(
            title: context.l10n.forgeContentConstraintsTitle,
            emphasis: PanelEmphasis.secondary,
            child: Column(
              children: [
                ToggleTile(
                  label: context.l10n.forgeIncludeNpcsLabel,
                  subtitle: context.l10n.forgeIncludeNpcsSubtitle,
                  value: _includeNpcs,
                  onChanged: (value) {
                    _markDirty(() {
                      _includeNpcs = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                ToggleTile(
                  label: context.l10n.forgeIncludeEncountersLabel,
                  subtitle: context.l10n.forgeIncludeEncountersSubtitle,
                  value: _includeEncounters,
                  onChanged: (value) {
                    _markDirty(() {
                      _includeEncounters = value;
                    });
                  },
                ),
                const SizedBox(height: 14),
                _buildLoreTextField(
                  controller: _safetyNotesController,
                  label: context.l10n.forgeSafetyNotesLabel,
                  hintText: context.l10n.forgeSafetyNotesHint,
                  minLines: 2,
                  maxLines: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoreTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    int minLines = 2,
    int maxLines = 4,
    bool enableSuggestions = true,
    bool isPremiumLocked = false,
    Color? premiumCrownColor,
    VoidCallback? onPremiumLockedTap,
  }) {
    final textField = TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      autocorrect: enableSuggestions,
      enableSuggestions: enableSuggestions,
      enabled: !isPremiumLocked,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        labelStyle: isPremiumLocked && premiumCrownColor != null
            ? TextStyle(color: premiumCrownColor)
            : null,
        suffixIcon: isPremiumLocked && premiumCrownColor != null
            ? Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FaIcon(
                  FontAwesomeIcons.crown,
                  size: 16,
                  color: premiumCrownColor,
                ),
              )
            : null,
      ),
      onChanged: (_) {
        if (!_hasUnsavedChanges) {
          _markDirty();
        }
      },
    );

    if (!isPremiumLocked || onPremiumLockedTap == null) return textField;

    return GestureDetector(
      onTap: onPremiumLockedTap,
      child: AbsorbPointer(child: textField),
    );
  }

  Widget _buildChipWrap(
    List<String> values,
    Set<String> selectedValues,
    void Function(String value, bool selected) onSelected, {
    Set<String> premiumOptionIds = const {},
    Color? premiumCrownColor,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values.map((value) {
        final isPremium = premiumOptionIds.contains(value);
        final isLocked = isPremium && !_isPremiumUnlocked;
        return AnimatedRuneFilterChip(
          atmosphere: _currentAtmosphere(),
          label: value,
          selected: selectedValues.contains(value),
          onSelected: (selected) => onSelected(value, selected),
          premiumCrownColor: isPremium ? premiumCrownColor : null,
          onLockedTap: isLocked
              ? () => _showPremiumUnlockForChip(premiumCrownColor!)
              : null,
        );
      }).toList(),
    );
  }

  Widget _buildCustomChipSection({
    required List<String> options,
    required Set<String> selectedValues,
    required Set<String> customEntries,
    required void Function(String, bool) onSelected,
    required void Function(String) onRemoveCustom,
    required String dialogTitle,
    required String dialogHint,
  }) {
    final atmosphere = _currentAtmosphere();
    final premiumOptionIds = options.length >= 2
        ? {options[options.length - 2], options.last}
        : options.isNotEmpty
            ? {options.last}
            : const <String>{};

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...options.map((value) {
          final isPremium = premiumOptionIds.contains(value);
          final isLocked = isPremium && !_isPremiumUnlocked;
          return AnimatedRuneFilterChip(
            atmosphere: atmosphere,
            label: value,
            selected: selectedValues.contains(value),
            onSelected: (sel) {
              _triggerLightImpact();
              _markDirty(() => onSelected(value, sel));
            },
            premiumCrownColor: isPremium ? atmosphere.glow : null,
            onLockedTap: isLocked
                ? () => _showPremiumUnlockForChip(atmosphere.glow)
                : null,
          );
        }),
        ...customEntries.map((entry) {
          final atmospherePrimary =
              _resolvedAtmosphereTheme().colorScheme.primary;
          final chip = Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _markDirty(() => onRemoveCustom(entry)),
              borderRadius: BorderRadius.circular(999),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  color: atmospherePrimary.withValues(alpha: 0.84),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: atmospherePrimary.withValues(alpha: 0.68),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 6,
                    top: 6,
                    bottom: 6,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        entry,
                        style: _resolvedAtmosphereTheme()
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: FantasyPalette.parchment),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.close,
                        size: 12,
                        color: FantasyPalette.parchment.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
          return Stack(
            clipBehavior: Clip.none,
            children: [
              chip,
              Positioned(
                top: -1,
                right: -2,
                child: FaIcon(
                  FontAwesomeIcons.crown,
                  size: 13,
                  color: atmosphere.glow,
                ),
              ),
            ],
          );
        }),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: !_isPremiumUnlocked
                    ? () => _showPremiumUnlockForChip(atmosphere.glow)
                    : () => _showCustomEntryDialog(
                          title: dialogTitle,
                          hint: dialogHint,
                          onAdd: (value) =>
                              _markDirty(() => customEntries.add(value)),
                        ),
                borderRadius: BorderRadius.circular(999),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    color: _resolvedAtmosphereTheme()
                        .colorScheme
                        .surfaceContainerHighest
                        .withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: atmosphere.glow.withValues(alpha: 0.45),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(FontAwesomeIcons.plus,
                            size: 10, color: atmosphere.glow),
                        const SizedBox(width: 5),
                        Text(
                          'Custom',
                          style: _resolvedAtmosphereTheme()
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: atmosphere.glow),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: -1,
              right: -2,
              child: FaIcon(
                FontAwesomeIcons.crown,
                size: 13,
                color: atmosphere.glow,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildThemesChipSection(CampaignOptions options) =>
      _buildCustomChipSection(
        options: options.themes,
        selectedValues: _selectedThemes,
        customEntries: _customThemeEntries,
        onSelected: (v, sel) =>
            sel ? _selectedThemes.add(v) : _selectedThemes.remove(v),
        onRemoveCustom: (v) => _customThemeEntries.remove(v),
        dialogTitle: 'Custom Theme',
        dialogHint: 'e.g. Noir, Cosmic Horror…',
      );

  Widget _buildTonesChipSection(CampaignOptions options) =>
      _buildCustomChipSection(
        options: options.tones,
        selectedValues: _selectedTones,
        customEntries: _customToneEntries,
        onSelected: (v, sel) =>
            sel ? _selectedTones.add(v) : _selectedTones.remove(v),
        onRemoveCustom: (v) => _customToneEntries.remove(v),
        dialogTitle: 'Custom Tone',
        dialogHint: 'e.g. Melancholic, Tense…',
      );

  Widget _buildStylesChipSection(CampaignOptions options) =>
      _buildCustomChipSection(
        options: options.styles,
        selectedValues: _selectedStyles,
        customEntries: _customStyleEntries,
        onSelected: (v, sel) =>
            sel ? _selectedStyles.add(v) : _selectedStyles.remove(v),
        onRemoveCustom: (v) => _customStyleEntries.remove(v),
        dialogTitle: 'Custom Style',
        dialogHint: 'e.g. Gritty Realism, Fairy Tale…',
      );

  void _showCustomEntryDialog({
    required String title,
    required String hint,
    required ValueChanged<String> onAdd,
  }) {
    final stableContext = context;
    final atmosphereTheme = _resolvedAtmosphereTheme();
    final glow = _currentAtmosphere().glow;
    final controller = TextEditingController();
    showDialog<String>(
      context: stableContext,
      builder: (dialogContext) => Theme(
        data: atmosphereTheme,
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: stableContext.fantasy.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: glow.withValues(alpha: 0.35)),
              boxShadow: [
                BoxShadow(
                  color: glow.withValues(alpha: 0.12),
                  blurRadius: 28,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: atmosphereTheme.textTheme.titleMedium?.copyWith(
                        color: glow,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(width: 8),
                    FaIcon(FontAwesomeIcons.crown, size: 14, color: glow),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  autofocus: true,
                  cursorColor: glow,
                  style: atmosphereTheme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: atmosphereTheme.textTheme.bodyMedium?.copyWith(
                      color: atmosphereTheme.colorScheme.onSurface
                          .withValues(alpha: 0.38),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: glow.withValues(alpha: 0.35)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: glow, width: 1.5),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (value) =>
                      Navigator.of(dialogContext).pop(value.trim()),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              color: glow.withValues(alpha: 0.7)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.of(dialogContext)
                            .pop(controller.text.trim()),
                        style: FilledButton.styleFrom(
                          backgroundColor: glow.withValues(alpha: 0.84),
                          foregroundColor: FantasyPalette.parchment,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Add'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).then((value) {
      if (value != null && value.isNotEmpty && mounted) {
        _triggerLightImpact();
        onAdd(value);
      }
    });
  }

  void _scrollForgeToRevealCreativePanel() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_forgeScrollController.hasClients) return;
      final maxExtent = _forgeScrollController.position.maxScrollExtent;
      final target =
          (_forgeScrollController.offset + 380.0).clamp(0.0, maxExtent);
      _forgeScrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    });
  }
}
