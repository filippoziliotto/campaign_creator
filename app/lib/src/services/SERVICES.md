# services

Questa cartella contiene il layer di accesso ai dati e il motore locale di generazione prompt.
Nel progetto attuale non esiste un backend runtime: opzioni e template sono inclusi come asset dell'app.

## Responsabilita

- caricare gli asset YAML e markdown dal bundle Flutter
- tradurre asset e input utente in modelli e prompt finali
- offrire un'interfaccia testabile usata dalla shell UI

## File

- `campaign_service.dart`
  Interfaccia astratta usata dalla UI per caricare opzioni e generare il prompt.

- `local_campaign_service.dart`
  Implementazione offline che legge asset locali e rende i template sul dispositivo.

## Cosa fa `LocalCampaignService`

`LocalCampaignService` non dipende dalla rete. Usa `rootBundle` per leggere:

Metodi pubblici:

- `getOptions()`
  Carica `options.yaml` o `options_en.yaml`, effettua il parsing e restituisce `CampaignOptions`.

- `generatePrompt(CampaignGenerateRequest request)`
  Seleziona il template corretto, costruisce il contesto e restituisce il prompt markdown finale.

## Gestione errori

Gli errori derivano principalmente da:

- asset mancanti o malformati
- input utente non valido per la generazione
- problemi di parsing del template o delle opzioni

## Linee guida

- nessun widget Flutter in questo layer
- nessuna logica di layout o navigazione
- mantenere i metodi piccoli e orientati al contratto del service
- aggiungere qui nuove sorgenti dati locali o nuovi renderer invece di spargere parsing nella UI

## Quando modificarla

Aggiorna questa cartella quando:

- cambiano opzioni o template inclusi nell'app
- cambia il formato dei file asset
- vuoi introdurre caching locale o validazioni aggiuntive

Se in futuro il progetto cresce, questa cartella e il posto giusto per separare:

- repository di dominio
- eventuale cache locale o persistenza offline
- strategie diverse di generazione del prompt
