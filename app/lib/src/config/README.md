# config

Questa cartella contiene la configurazione runtime del frontend.
Non deve contenere logica di business, networking o trasformazioni dati complesse.

## Responsabilita

- esporre parametri applicativi letti da `--dart-define`
- fornire valori di default sicuri per lo sviluppo locale
- centralizzare le costanti runtime usate da piu moduli

## File

- `app_config.dart`
  Espone `AppConfig.apiBaseUrl`.
  Il valore viene letto da `String.fromEnvironment('API_BASE_URL')`.
  Se non viene passato nessun `--dart-define`, il client usa il valore di default hardcoded.
  In sviluppo locale: `--dart-define=API_BASE_URL=http://10.0.2.2:8000` (Android emulator)
  o `--dart-define=API_BASE_URL=http://127.0.0.1:8000` (iOS simulator).
  Per i build di produzione e obbligatorio passare `--dart-define=API_BASE_URL=https://...`
  puntando al backend deployato.

## Come viene usata

Il valore viene consumato nella shell del builder per istanziare `BackendApi`.
Questo evita che i widget conoscano direttamente l'URL dell'API o hardcodino endpoint in piu punti.

## Linee guida

- tenere qui solo configurazione runtime o feature flag di basso livello
- evitare di mettere qui costanti di UI che appartengono al tema
- evitare di mettere qui helper di rete: quelli appartengono a `services/`

## Quando modificarla

Aggiorna questa cartella quando:

- cambia l'URL del backend
- aggiungi ambienti multipli
- introduci flag di comportamento frontend guidati da build o deployment
