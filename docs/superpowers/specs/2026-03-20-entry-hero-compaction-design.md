# Entry Hero Compaction Design

## Context

The current Entry hero solved the original "cards in space" problem but created a larger one on mobile:

- it duplicates brand/chrome already present in the top bar
- it consumes too much vertical space on iPhone-sized screens
- it competes with the real primary action, which is choosing a campaign type
- it adds decorative substructure (`badge`, `sigil`, helper footer) that reads as visual noise

The user wants to keep the stronger title direction, but simplify the hero so the first screen feels cleaner and more focused.

## Goal

Make the Entry screen feel like a **mobile-first chooser**, not a landing page.

The hero should:

- introduce the app in one read
- stop competing with the campaign cards
- stay compact enough that the first card row is immediately visible on iPhone

## Approved Direction

### Entry Hero

Replace the current rich `HeroFrame` content with a compact static intro block in the existing `hero` slot.

Approved copy:

- title: `Choose your Campaign`
- subtitle: `Forge your campaign prompt, then bring it to your AI of choice.`

Remove from the hero:

- eyebrow (`Campaign Creator`)
- badge (`Format`)
- trailing icon/sigil card
- helper/footer line

The hero should remain **static** before and after campaign selection.

### Selection Behavior

Selection feedback belongs on the campaign cards, not in the hero.

That means:

- keep the stronger selected card state already added
- do not mutate the hero after selection

### Mobile Layout

The Entry layout should prioritize seeing the choice set quickly.

Adjustments:

- reduce hero vertical mass significantly
- reduce hero-to-grid spacing
- preserve the current 1-column / 2-column grid logic
- keep the resume panel below the grid

## Files in Scope

- `app/lib/src/ui/pages/shell/campaign_builder_entry_shell.dart`
- `app/lib/src/ui/pages/routes/entry_page.dart`
- `app/lib/l10n/app_it.arb`
- `app/lib/l10n/app_en.arb`
- `app/test/ui/pages/shell/campaign_builder_entry_hero_test.dart`

Potentially touched, but only if needed:

- `app/lib/src/ui/pages/design/campaign_builder_primitives.dart`

## Implementation Notes

### Entry Shell

In `campaign_builder_entry_shell.dart`:

- replace the current `_buildEntryHero(...)` composition with a minimal intro block
- keep using the `hero:` slot on `EntryRoutePage`
- remove the current sigil helper entirely if no longer needed

### Entry Page Spacing

In `entry_page.dart`:

- tighten the gap between hero and campaign grid so the first row reads earlier on phone screens

### Localization

Update localized strings to the approved copy in Italian and English.

Italian should preserve the same simple/product-oriented meaning without naming a specific AI brand.

### Tests

Update Entry tests to reflect the new contract:

- hero renders in compact form
- hero stays static after campaign selection
- Entry still renders correctly on narrow mobile widths
- no overflow/regression introduced by the smaller hero

## Non-Goals

This pass does not:

- redesign Forge or Parchment
- rewrite the top bar
- change campaign card layout structure
- introduce new motion systems or decorative effects

## Success Criteria

On iPhone-width layouts:

- the hero feels compact, not theatrical
- the first card row is visible immediately
- the screen no longer feels like "top bar + another top bar + cards"
- campaign selection is visually the main decision point
