part of 'campaign_builder_page.dart';

extension on _CampaignBuilderPageState {
  Widget _buildForgeStage(CampaignOptions options) {
    final atmosphere = _currentAtmosphere(options);
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
      activeSection: _revealed(
        delay: 0.18,
        atmosphere: atmosphere,
        child: _buildActiveForgeSection(options),
      ),
      controlPanel: _revealed(
        delay: 0.22,
        atmosphere: atmosphere,
        child: _buildForgeControlPanel(),
      ),
    );
  }

  Widget _buildForgeSectionRibbon() {
    return SegmentedButton<_ForgeSection>(
      showSelectedIcon: false,
      segments: _ForgeSection.values.map((section) {
        final index = _ForgeSection.values.indexOf(section);
        final completed = index < _ForgeSection.values.indexOf(_forgeSection);
        return ButtonSegment<_ForgeSection>(
          value: section,
          label: Text(_forgeSectionLabel(section)),
          icon: completed
              ? const Icon(Icons.check_circle_rounded)
              : Icon(_forgeSectionIcon(section)),
        );
      }).toList(),
      selected: {_forgeSection},
      onSelectionChanged: (selection) {
        _applyShellState(() {
          _setForgeSection(selection.first);
        });
      },
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
        key: ValueKey<String>(_forgeSection.name),
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
      primaryLabel: _isGenerating ? 'Forgiando...' : _nextForgeActionLabel(),
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
          readyText: 'Il mondo e pronto: puoi passare al party.',
          pendingText:
              'Definisci formato, ambientazione e almeno una firma creativa.',
        );
      case _ForgeSection.party:
        return _primaryActionHint(
          ready: _canAdvancePartySection(),
          readyText: 'Il party e pronto per aprire la trama.',
          pendingText:
              'Controlla livello, dimensione e archetipi del gruppo.',
        );
      case _ForgeSection.narrative:
        return _primaryActionHint(
          ready: _canForgeNarrativeSection(),
          readyText: 'Hai abbastanza materiale per forgiare la pergamena.',
          pendingText:
              'Aggiungi almeno un segnale narrativo prima di generare.',
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

    return SectionFrame(
      eyebrow: 'Atto I',
      title: 'Mondo e firma creativa',
      subtitle: 'Definisci formato, ambientazione, twist e tono della campagna.',
      icon: Icons.map_rounded,
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
                      presets,
                      effectiveSelectedPreset,
                      presetDescription,
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
    );
  }

  Widget _buildWorldFoundationPanel(
    CampaignOptions options,
    List<String> presets,
    String? effectiveSelectedPreset,
    String? presetDescription,
    String? settingDescription,
  ) {
    return ControlRoomPanel(
      label: 'Fondazione',
      title: 'Assetto campagna',
      subtitle: 'Formato, preset rapido e ambientazione operativa.',
      icon: Icons.public_rounded,
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
                      label: 'Preset rapido',
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
                      onPressed:
                          effectiveSelectedPreset == null ? null : _applyPreset,
                      child: const Text('Applica preset'),
                    ),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildStringDropdown(
                      label: 'Preset rapido',
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
                    onPressed:
                        effectiveSelectedPreset == null ? null : _applyPreset,
                    child: const Text('Applica'),
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
          const SizedBox(height: 14),
          _buildStringDropdown(
            label: 'Ambientazione',
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
            label: 'Dettaglio ambientazione personalizzato',
            hintText:
                'Regno in guerra, frontiera sospesa, città verticale, arcipelago infernale...',
            minLines: 2,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildWorldTwistPanel(CampaignOptions options) {
    return ControlRoomPanel(
      label: 'Rottura',
      title: 'Twist iniziale',
      subtitle: 'Scegli il colpo di scena o scrivine uno personalizzato.',
      icon: Icons.bolt_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStringDropdown(
            label: 'Twist',
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
            label: 'Twist personalizzato',
            hintText: 'Un alleato mente, il dungeon e vivo, la missione e una trappola...',
            minLines: 2,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildCreativeDirectionPanel(CampaignOptions options) {
    return ControlRoomPanel(
      label: 'Firma creativa',
      title: 'Temi, tono e stile',
      subtitle: 'Seleziona le direttrici principali della campagna.',
      icon: Icons.palette_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Temi', style: _resolvedAtmosphereTheme().textTheme.titleMedium),
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
            label: 'Temi personalizzati',
            hintText: 'Intrigo politico, redenzione, sopravvivenza, orrore cosmico...',
            minLines: 2,
            maxLines: 3,
          ),
          const SizedBox(height: 18),
          Text('Tono', style: _resolvedAtmosphereTheme().textTheme.titleMedium),
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
          Text('Stile', style: _resolvedAtmosphereTheme().textTheme.titleMedium),
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
            label: 'Override tono e stile',
            hintText: 'Es: tono: cupo, epico\nstile: sandbox, mystery',
            minLines: 2,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildPartySection(CampaignOptions options) {
    return SectionFrame(
      eyebrow: 'Atto II',
      title: 'Party e scala di gioco',
      subtitle: 'Imposta livello, dimensione del gruppo e archetipi principali.',
      icon: Icons.groups_rounded,
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
            label: 'Note del party',
            title: 'Informazioni utili',
            subtitle: 'Dettagli che influenzano la costruzione del prompt.',
            icon: Icons.badge_rounded,
            child: Column(
              children: [
                _buildLoreTextField(
                  controller: _characterNotesController,
                  label: 'Note sui personaggi',
                  hintText: 'Segreti, legami, paure, background importanti...',
                  minLines: 3,
                  maxLines: 5,
                ),
                const SizedBox(height: 14),
                _buildLoreTextField(
                  controller: _constraintsController,
                  label: 'Vincoli',
                  hintText: 'Durata breve, niente viaggi planari, boss finale obbligatorio...',
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
      label: 'Scala',
      title: 'Livello e dimensione',
      subtitle: 'La difficolta e il numero di PG definiscono il perimetro del prompt.',
      icon: Icons.tune_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Livello party: $_partyLevel',
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
            'Numero personaggi: $_partySize',
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
      label: 'Ruoli',
      title: 'Archetipi del party',
      subtitle: 'Seleziona fino a $_partySize archetipi.',
      icon: Icons.shield_outlined,
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
              text:
                  'Hai raggiunto il massimo di archetipi selezionabili per il party attuale.',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNarrativeSection() {
    return SectionFrame(
      eyebrow: 'Atto III',
      title: 'Pressione narrativa',
      subtitle: 'Aggiungi agganci, fazioni, incontri e note di sicurezza.',
      icon: Icons.auto_stories_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ControlRoomPanel(
            label: 'Agganci',
            title: 'Trama e forze in gioco',
            subtitle: 'Gli elementi che il backend usera per costruire la pergamena.',
            icon: Icons.hub_rounded,
            child: Column(
              children: [
                _buildLoreTextField(
                  controller: _narrativeHooksController,
                  label: 'Agganci narrativi',
                  hintText: 'Missione iniziale, minaccia, mistero, countdown...',
                  minLines: 3,
                  maxLines: 5,
                ),
                const SizedBox(height: 14),
                _buildLoreTextField(
                  controller: _factionsController,
                  label: 'Fazioni e poteri',
                  hintText: 'Gilde, culti, casate, antagonisti, alleati instabili...',
                  minLines: 2,
                  maxLines: 4,
                ),
                const SizedBox(height: 14),
                _buildLoreTextField(
                  controller: _npcFocusController,
                  label: 'NPC chiave',
                  hintText: 'Mentore ambiguo, rivale, patrono, traditore...',
                  minLines: 2,
                  maxLines: 4,
                ),
                const SizedBox(height: 14),
                _buildLoreTextField(
                  controller: _encounterFocusController,
                  label: 'Incontri desiderati',
                  hintText: 'Assedio, indagine sociale, inseguimento, boss finale...',
                  minLines: 2,
                  maxLines: 4,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ControlRoomPanel(
            label: 'Sicurezza',
            title: 'Vincoli di contenuto',
            subtitle: 'Definisci cosa includere e cosa evitare.',
            icon: Icons.rule_rounded,
            child: Column(
              children: [
                ToggleTile(
                  label: 'Includi NPC',
                  subtitle: 'Il prompt includera personaggi non giocanti rilevanti.',
                  value: _includeNpcs,
                  onChanged: (value) {
                    _markDirty(() {
                      _includeNpcs = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                ToggleTile(
                  label: 'Includi incontri',
                  subtitle: 'Il prompt suggerira scene e combattimenti.',
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
                  label: 'Note di sicurezza',
                  hintText: 'Temi da evitare, linee e veli, limiti di tono...',
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
    final normalizedValue =
        options.contains(value) ? value : (options.isNotEmpty ? options.first : null);
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
      spacing: 10,
      runSpacing: 10,
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
