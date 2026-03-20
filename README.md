# Campaign Forge — D&D Campaign Creator

A fully offline D&D campaign prompt generator. Flutter mobile app (iOS + Android) with no backend required — all options and prompt generation run on-device.

## Architecture

- `app/` — Flutter frontend (iOS + Android)
  - `app/assets/data/` — bundled YAML option files (Italian + English)
  - `app/assets/templates/` — bundled Jinja2-style prompt templates
  - `app/lib/src/services/local_campaign_service.dart` — on-device prompt generation
- `docs/` — privacy policy and project documentation

## Setup

### Flutter App

Requires Flutter SDK.

```bash
cd app
flutter pub get
flutter run
```

## Build

```bash
cd app
flutter build appbundle
flutter build ipa
```

## Output

The app produces a structured D&D campaign prompt ready to paste into ChatGPT. The optional "Open in ChatGPT" action opens `chatgpt.com` in a browser and copies the prompt to the clipboard.
