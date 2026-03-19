# models

Questa cartella definisce i tipi dati scambiati tra UI e backend.
Il suo ruolo e rendere esplicito il contratto applicativo del frontend, evitando JSON anonimo sparso nei widget.

## Responsabilita

- tipizzare i payload ricevuti dal backend
- serializzare le request inviate dal frontend
- offrire piccoli helper di dominio legati ai dati, non alla UI

## File

- `campaign_models.dart`
  Contiene i due tipi principali del progetto:
  - `CampaignOptions`: rappresenta il payload di `/options`
  - `CampaignGenerateRequest`: rappresenta il payload inviato a `/generate`

## Dettagli implementativi

### `CampaignOptions`

Gestisce:

- liste di opzioni selezionabili (`settings`, `campaignTypes`, `themes`, `tones`, `styles`, `partyArchetypes`, `twists`)
- descrizioni testuali di ambientazioni e preset
- mappa completa dei preset backend

Helper esposti:

- `CampaignOptions.fromJson(...)`: parsing del payload backend
- `presetsForCampaignType(...)`: filtra i preset per tipo campagna
- `presetByName(...)`: recupera un preset per chiave

### `CampaignGenerateRequest`

Rappresenta il payload finale costruito dalla flow utente.
Tiene insieme:

- setting e tipo campagna
- preferenze di tema, tono e stile
- dati del party
- twist
- hook narrativi e note custom
- flag su NPC e incontri
- lingua di output

Helper esposto:

- `toJson()`: serializza il payload in forma compatibile con l'API backend

## Regole di progettazione

- niente dipendenze da Flutter UI
- niente chiamate HTTP
- niente stato mutabile condiviso
- piccoli helper di dominio sono accettabili se riguardano il modello stesso

## Quando modificarla

Aggiorna questa cartella quando:

- il backend cambia il contratto JSON
- aggiungi nuovi campi alla flow del builder
- servono helper di parsing o normalizzazione legati al payload

Se un cambiamento riguarda layout, stili o interazioni visive, non appartiene qui.
