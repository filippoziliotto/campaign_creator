# Entry Hero Compaction Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the current oversized Entry hero with a compact static intro so the first campaign card row is visible earlier on mobile and selection focus returns to the cards.

**Architecture:** Keep the existing `hero` slot on `EntryRoutePage`, but stop using the rich reactive `HeroFrame` composition for Entry. Build a small local intro block in the entry shell, keep card emphasis on the campaign cards, and update tests to lock in the new static hero contract.

**Tech Stack:** Flutter, Dart, Flutter widget tests, Flutter l10n ARB localization

---

## File Structure

- Modify: `app/lib/src/ui/pages/shell/campaign_builder_entry_shell.dart`
  - Replace `_buildEntryHero(...)` with a compact static intro block.
  - Remove the now-unneeded `_buildEntryHeroSigil(...)`.
  - Stop changing hero copy based on `_selectedCampaignType`.
- Modify: `app/lib/src/ui/pages/routes/entry_page.dart`
  - Tighten hero-to-grid spacing for phone layouts.
- Modify: `app/lib/l10n/app_en.arb`
  - Update hero title/body copy to the approved text.
- Modify: `app/lib/l10n/app_it.arb`
  - Add matching Italian copy with the same simple product tone.
- Modify: `app/test/ui/pages/shell/campaign_builder_entry_hero_test.dart`
  - Update tests for a static compact hero.
- Verify only if needed: `app/lib/src/ui/pages/design/campaign_builder_primitives.dart`
  - Do not change primitives unless the compact hero cannot be expressed cleanly in the shell.

## Chunk 1: Replace the Entry Hero

### Task 1: Make the Entry hero static and compact

**Files:**
- Modify: `app/lib/src/ui/pages/shell/campaign_builder_entry_shell.dart`
- Modify: `app/lib/src/ui/pages/routes/entry_page.dart`
- Modify: `app/lib/l10n/app_en.arb`
- Modify: `app/lib/l10n/app_it.arb`

- [ ] **Step 1: Write the failing test for a static hero**

Update `app/test/ui/pages/shell/campaign_builder_entry_hero_test.dart` so the selection test asserts:

```dart
expect(find.text('Choose your Campaign'), findsOneWidget);
expect(
  find.text('Forge your campaign prompt, then bring it to your AI of choice.'),
  findsOneWidget,
);

await tester.tap(
  find.byKey(const ValueKey<String>('entry-campaign-card-One-Shot')),
);
await _pumpUi(tester);

expect(find.text('Choose your Campaign'), findsOneWidget);
expect(
  find.text('Forge your campaign prompt, then bring it to your AI of choice.'),
  findsOneWidget,
);
expect(find.text('Select a format to begin.'), findsNothing);
```

- [ ] **Step 2: Run the focused test and verify it fails**

Run:

```bash
cd app
flutter test test/ui/pages/shell/campaign_builder_entry_hero_test.dart
```

Expected: FAIL because the current hero still changes after selection and still renders extra decorative content.

- [ ] **Step 3: Replace the current Entry hero composition**

In `app/lib/src/ui/pages/shell/campaign_builder_entry_shell.dart`, replace the current `HeroFrame`-based builder with a local compact container:

```dart
Widget _buildEntryHero() {
  final atmosphere = _defaultCampaignMeta.atmosphere;
  final theme = _resolvedAtmosphereTheme();

  return Container(
    key: const ValueKey<String>('entry-hero'),
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: atmosphere.primary.withValues(alpha: 0.24),
      ),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Color.lerp(FantasyPalette.shadow, atmosphere.cardTint, 0.10)!,
          Color.lerp(FantasyPalette.card, atmosphere.cardTint, 0.16)!,
        ],
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.entryHeroWelcomeTitle,
          style: theme.textTheme.displaySmall,
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.entryHeroWelcomeBody,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    ),
  );
}
```

Implementation rules:
- no eyebrow
- no badge list
- no trailing sigil
- no footer
- no selection-dependent content
- delete `_buildEntryHeroSigil(...)` if unused

- [ ] **Step 4: Tighten Entry spacing**

In `app/lib/src/ui/pages/routes/entry_page.dart`, reduce the hero-to-grid gap:

```dart
const SizedBox(height: 24) -> const SizedBox(height: 14)
```

Keep the resume-panel gap unchanged unless the updated layout still feels too tall during manual review.

- [ ] **Step 5: Update localized copy**

In `app/lib/l10n/app_en.arb`:

```json
"entryHeroWelcomeTitle": "Choose your Campaign",
"entryHeroWelcomeBody": "Forge your campaign prompt, then bring it to your AI of choice."
```

In `app/lib/l10n/app_it.arb`:

```json
"entryHeroWelcomeTitle": "Scegli la tua campagna",
"entryHeroWelcomeBody": "Forgia il prompt della tua campagna, poi portalo nella tua AI di fiducia."
```

Do not add new strings for helper/footer copy in this pass.

- [ ] **Step 6: Regenerate localization output**

Run:

```bash
cd app
flutter gen-l10n
```

Expected: PASS with generated localization classes updated.

- [ ] **Step 7: Re-run the focused hero test**

Run:

```bash
cd app
flutter test test/ui/pages/shell/campaign_builder_entry_hero_test.dart
```

Expected: PASS.

## Chunk 2: Lock In Mobile Layout and Regressions

### Task 2: Update tests to reflect the compact hero contract

**Files:**
- Modify: `app/test/ui/pages/shell/campaign_builder_entry_hero_test.dart`

- [ ] **Step 1: Update the existing entry tests**

Make the test file cover the new behavior:

- hero renders above the grid
- hero remains static after selecting a campaign type
- no overflow on narrow mobile width

Use stable finders:

```dart
find.byKey(const ValueKey<String>('entry-hero'))
find.byKey(const ValueKey<String>('entry-campaign-card-One-Shot'))
```

- [ ] **Step 2: Add one narrow-layout visibility assertion**

Assert the first card is still present and laid out below the hero:

```dart
final heroRect = tester.getRect(find.byKey(const ValueKey<String>('entry-hero')));
final cardRect = tester.getRect(
  find.byKey(const ValueKey<String>('entry-campaign-card-One-Shot')),
);
expect(heroRect.bottom, lessThan(cardRect.top));
```

- [ ] **Step 3: Run the focused test file**

Run:

```bash
cd app
flutter test test/ui/pages/shell/campaign_builder_entry_hero_test.dart
```

Expected: PASS.

### Task 3: Run full verification

**Files:**
- No code changes expected

- [ ] **Step 1: Run analyzer**

Run:

```bash
cd app
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 2: Run the full test suite**

Run:

```bash
cd app
flutter test
```

Expected: all tests pass.

- [ ] **Step 3: Manual mobile check**

Run:

```bash
cd app
flutter run
```

Manual checks on iPhone-width simulator/device:
- hero shows only title + subtitle
- no repeated `Campaign Creator` inside the hero
- no `Format` pill
- no icon/sigil block
- first card row is visible earlier than before
- selected cards still carry the visual emphasis

- [ ] **Step 4: Commit**

```bash
git add \
  app/lib/src/ui/pages/shell/campaign_builder_entry_shell.dart \
  app/lib/src/ui/pages/routes/entry_page.dart \
  app/lib/l10n/app_en.arb \
  app/lib/l10n/app_it.arb \
  app/test/ui/pages/shell/campaign_builder_entry_hero_test.dart
git commit -m "refactor: compact the entry hero"
```
