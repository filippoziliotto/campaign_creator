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
    final segments = _ForgeSection.values.map((section) {
      final index = _ForgeSection.values.indexOf(section);
      final completed = index < _ForgeSection.values.indexOf(_forgeSection);
      return ButtonSegment<_ForgeSection>(
        value: section,
        label: Text(_forgeSectionLabel(section)),
        icon: completed
            ? const Icon(Icons.check_circle_rounded)
            : Icon(_forgeSectionIcon(section)),
      );
    }).toList();

    return Theme(
      data: _resolvedAtmosphereTheme().copyWith(
        segmentedButtonTheme: SegmentedButtonThemeData(
          style: ButtonStyle(
            visualDensity: VisualDensity.compact,
            padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final button = SegmentedButton<_ForgeSection>(
            showSelectedIcon: false,
            segments: segments,
            selected: {_forgeSection},
            onSelectionChanged: (selection) {
              _applyShellState(() {
                _setForgeSection(selection.first);
              });
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
        return SharedAxisTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: atmosphere.sectionTransitionType,
          fillColor: Colors.transparent,
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
                        child: _buildWorldFoundationPanel(
                          options,
                          settingDescription,
                        ),
                      ),
                      SizedBox(
                        width: pairedWidth,
                        child: _buildWorldTwistPanel(options),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 18),
              _buildCreativeDirectionPanel(options),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SectionFrame(
          title: context.l10n.forgePresetSectionTitle,
          subtitle: context.l10n.forgePresetSectionSubtitle,
          density: FrameDensity.featured,
          child: _buildPresetsPanel(
            presets,
            effectiveSelectedPreset,
            presetDescription,
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
      showDivider: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStringDropdown(
            label: context.l10n.forgeSettingLabel,
            value: _selectedSetting,
            options: options.settings,
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
            minLines: 2,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildPresetsPanel(
    List<String> presets,
    String? effectiveSelectedPreset,
    String? presetDescription,
  ) {
    return ControlRoomPanel(
      label: context.l10n.forgePresetPanelLabel,
      title: context.l10n.forgePresetPanelTitle,
      subtitle: context.l10n.forgePresetPanelSubtitle,
      icon: Icons.bolt_rounded,
      density: FrameDensity.featured,
      showDivider: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 520;
              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildStringDropdown(
                      label: context.l10n.forgeQuickPresetLabel,
                      value: effectiveSelectedPreset,
                      options: presets,
                      onChanged: (value) {
                        _markDirty(() {
                          _selectedPreset = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                      onPressed:
                          effectiveSelectedPreset == null ? null : _applyPreset,
                      child: Text(context.l10n.forgeApplyPreset),
                    ),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildStringDropdown(
                      label: context.l10n.forgeQuickPresetLabel,
                      value: effectiveSelectedPreset,
                      options: presets,
                      onChanged: (value) {
                        _markDirty(() {
                          _selectedPreset = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                    onPressed:
                        effectiveSelectedPreset == null ? null : _applyPreset,
                    child: Text(context.l10n.forgeApply),
                  ),
                ],
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStringDropdown(
            label: context.l10n.forgeTwistLabel,
            value: _selectedTwist,
            options: options.twists,
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

  Widget _buildCreativeDirectionPanel(CampaignOptions options) {
    return ControlRoomPanel(
      title: context.l10n.forgeCreativeTitle,
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
            minLines: 2,
            maxLines: 3,
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
            minLines: 2,
            maxLines: 4,
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
      title: context.l10n.forgeNarrativeSectionTitle,
      subtitle: context.l10n.forgeNarrativeSectionSubtitle,
      density: FrameDensity.featured,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ControlRoomPanel(
            title: context.l10n.forgeNarrativePanelTitle,
            icon: Icons.hub_rounded,
            density: FrameDensity.featured,
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

  Widget _buildStringDropdown({
    required String label,
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    final normalizedValue = options.contains(value)
        ? value
        : (options.isNotEmpty ? options.first : null);
    return DropdownButtonFormField<String>(
      initialValue: normalizedValue,
      isExpanded: true,
      items: options
          .map(
            (option) => DropdownMenuItem<String>(
              value: option,
              child: Text(
                option,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      selectedItemBuilder: (context) {
        return options
            .map(
              (option) => Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  option,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList();
      },
      onChanged: options.isEmpty ? null : onChanged,
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }

  Widget _buildLoreTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    int minLines = 2,
    int maxLines = 4,
  }) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
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
