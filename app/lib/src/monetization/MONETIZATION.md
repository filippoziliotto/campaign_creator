# monetization

Modulo di monetizzazione per Campaign Forge. Gestisce ads interstiziali e acquisto in-app "rimuovi pubblicita".

## File

- `ad_units.dart` — ID degli ad unit e del prodotto IAP. Nessuna logica.
- `interstitial_ad_service.dart` — Interfaccia e implementazione del wrapper per `google_mobile_ads`.
- `purchase_service.dart` — Interfaccia e implementazione del wrapper per `in_app_purchase`, con update normalizzati.
- `monetization_prefs.dart` — Chiavi SharedPreferences e helper per conteggio generazioni e stato ad-free.
- `monetization_coordinator.dart` — Policy e sequencing: decide quando mostrare un ad, gestisce gli entitlement di acquisto.

## Regole di dipendenza

- Questo modulo non dipende da `ui/`, `theme/` o `services/`.
- Puo dipendere da `shared_preferences` e dai plugin ads/IAP.
- La shell UI (`campaign_builder_page.dart`) dipende dalle interfacce esposte qui, mai direttamente dai plugin.
