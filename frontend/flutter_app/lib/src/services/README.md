# services

Questa cartella contiene il layer di integrazione con sistemi esterni.
Nel progetto attuale il solo sistema esterno e il backend Python esposto via FastAPI.

## Responsabilita

- incapsulare le chiamate HTTP
- tradurre errori di trasporto in eccezioni leggibili dalla UI
- convertire payload JSON in modelli del frontend

## File

- `backend_api.dart`
  Client applicativo verso il backend.

## Cosa fa `BackendApi`

`BackendApi` riceve un `baseUrl` e opzionalmente un `http.Client`.
Questo consente:

- configurazione da ambiente tramite `AppConfig`
- testabilita del layer di rete tramite client custom

Metodi pubblici:

- `getOptions()`
  Chiama `GET /options`, valida il formato della risposta e restituisce `CampaignOptions`.

- `generatePrompt(CampaignGenerateRequest request)`
  Chiama `POST /generate`, invia il JSON serializzato e restituisce il prompt testuale finale.

## Gestione errori

`BackendApiException` centralizza gli errori di rete e di payload.
La factory `fromResponse(...)` prova a leggere `detail` dalla risposta backend, cosi la UI puo mostrare un messaggio piu utile del semplice status code.

## Linee guida

- nessun widget Flutter in questo layer
- nessuna logica di layout o navigazione
- mantenere i metodi piccoli e orientati al contratto dell'API
- aggiungere qui nuovi endpoint invece di chiamare `http` direttamente dalla UI

## Quando modificarla

Aggiorna questa cartella quando:

- vengono aggiunti endpoint backend
- cambia il formato delle risposte
- vuoi introdurre timeout, retry, caching o logging HTTP

Se in futuro il progetto cresce, questa cartella e il posto giusto per separare:

- client HTTP raw
- repository di dominio
- eventuale cache locale o persistenza offline
