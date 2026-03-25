# design

Questa cartella contiene il design layer locale del campaign builder.
Qui vivono token visuali, backdrop, primitives e widget interattivi animati che devono essere riusati in piu schermate.

## File

### `campaign_builder_atmosphere.dart`

Definisce `CampaignAtmosphereData`.

Contiene:

- palette per tipo campagna
- glow, linework e tinta delle superfici
- varianti del backdrop
- timing delle transizioni
- motion token condivisi (`cardHoverLift`, `chipFlashDuration`, `ctaPulseDuration`, ecc.)

Questo file e il posto giusto per cambiare il carattere del prodotto per modalita.

### `campaign_builder_primitives.dart`

Contiene le primitives visuali riusabili:

- `CampaignStagePage`
- `HeroFrame`
- `CampaignModeCard`
- `StagePill`
- `AnimatedReveal`
- `SectionFrame`
- `SummaryBadge`
- `LoreCallout`
- `StatusSeal`
- `ToggleTile`
- `RuneDivider`
- `FantasyBackdrop`

Qui dovrebbero vivere solo blocchi di UI condivisi e privi di conoscenza del dominio applicativo.

### `campaign_builder_motion.dart`

Contiene widget interattivi con stato animato dedicato:

- `AnimatedRuneFilterChip`
- `ForgePrimaryActionButton`
- helper `prefersReducedMotion`

Questo file esiste per evitare che le micro-animazioni stateful tornino dentro la shell/controller.

## Regola di ownership

- Se cambia il linguaggio visivo condiviso: `campaign_builder_primitives.dart`
- Se cambiano token e intensita delle animazioni per mode: `campaign_builder_atmosphere.dart`
- Se cambia il comportamento di un widget interattivo animato: `campaign_builder_motion.dart`
