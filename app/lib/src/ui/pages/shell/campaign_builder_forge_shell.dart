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
            onChanged: (value) {
              _markDirty(() {
                _selectedSetting = value;
              });
            },
          ),
          if (settingDescription != null) ...[
            const SizedBox(height: 12),
            LoreCallout(
              icon: Icons.travel_explore_rounded,
              text: settingDescription,
            ),
          ],
          const SizedBox(height: 14),
          _buildLoreTextField(
            controller: _customSettingController,
            label: context.l10n.forgeCustomSettingLabel,
            hintText: context.l10n.forgeCustomSettingHint,
            minLines: 1,
            maxLines: 2,
            enableSuggestions: false,
          ),
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
  }) {
    final normalizedValue = options.contains(value)
        ? value
        : (defaultToFirstOption && options.isNotEmpty ? options.first : null);
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
              final selected = await _showOptionPicker(
                keyPrefix: keyPrefix,
                title: title,
                label: label,
                currentValue: normalizedValue,
                options: options,
                labels: labels,
                uppercaseText: uppercaseText,
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
  }) {
    final theme = _resolvedAtmosphereTheme();

    return showModalBottomSheet<String>(
      context: context,
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
                        itemCount: options.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          color: colorScheme.outline.withValues(alpha: 0.12),
                        ),
                        itemBuilder: (context, index) {
                          final option = options[index];
                          final isSelected = option == currentValue;
                          final displayLabel = uppercaseText
                              ? (labels[option] ?? option).toUpperCase()
                              : (labels[option] ?? option);

                          return ListTile(
                            key: ValueKey<String>(
                              '$keyPrefix-option-$index',
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            title: Text(displayLabel),
                            trailing: isSelected
                                ? Icon(
                                    Icons.check_circle_rounded,
                                    color: colorScheme.primary,
                                  )
                                : null,
                            onTap: () => Navigator.of(sheetContext).pop(option),
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
          _buildChipWrap(
            options.themes,
            _selectedThemes,
            (value, selected) {
              _triggerLightImpact();
              _markDirty(() {
                if (selected) {
                  _selectedThemes.add(value);
                } else {
                  _selectedThemes.remove(value);
                }
              });
            },
          ),
          const SizedBox(height: 14),
          _buildLoreTextField(
            controller: _customThemeController,
            label: context.l10n.forgeCustomThemesLabel,
            hintText: context.l10n.forgeCustomThemesHint,
            minLines: 1,
            maxLines: 2,
            enableSuggestions: false,
          ),
          const SizedBox(height: 18),
          Text(
            context.l10n.forgeToneTitle,
            style: _resolvedAtmosphereTheme().textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          _buildChipWrap(
            options.tones,
            _selectedTones,
            (value, selected) {
              _triggerLightImpact();
              _markDirty(() {
                if (selected) {
                  _selectedTones.add(value);
                } else {
                  _selectedTones.remove(value);
                }
              });
            },
          ),
          const SizedBox(height: 18),
          Text(
            context.l10n.forgeStyleTitle,
            style: _resolvedAtmosphereTheme().textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          _buildChipWrap(
            options.styles,
            _selectedStyles,
            (value, selected) {
              _triggerLightImpact();
              _markDirty(() {
                if (selected) {
                  _selectedStyles.add(value);
                } else {
                  _selectedStyles.remove(value);
                }
              });
            },
          ),
          const SizedBox(height: 14),
          _buildLoreTextField(
            controller: _customToneStyleController,
            label: context.l10n.forgeToneStyleOverrideLabel,
            hintText: context.l10n.forgeToneStyleOverrideHint,
            minLines: 1,
            maxLines: 2,
            enableSuggestions: false,
          ),
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
  }) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      autocorrect: enableSuggestions,
      enableSuggestions: enableSuggestions,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
      ),
      onChanged: (_) {
        if (!_hasUnsavedChanges) {
          _markDirty();
        }
      },
    );
  }

  Widget _buildChipWrap(
    List<String> values,
    Set<String> selectedValues,
    void Function(String value, bool selected) onSelected,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values.map((value) {
        return AnimatedRuneFilterChip(
          atmosphere: _currentAtmosphere(),
          label: value,
          selected: selectedValues.contains(value),
          onSelected: (selected) => onSelected(value, selected),
        );
      }).toList(),
    );
  }
}
