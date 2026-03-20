# models

Questa cartella definisce i tipi dati scambiati tra UI e service layer locale.
Il suo ruolo e rendere esplicito il contratto applicativo del frontend, evitando mappe anonime sparse nei widget.

## Responsabilita

- tipizzare le opzioni caricate dagli asset bundle
- rappresentare la richiesta di generazione costruita dalla UI
- offrire piccoli helper di dominio legati ai dati, non alla UI

## File

- `campaign_models.dart`
  Contiene i due tipi principali del progetto:
  - `CampaignOptions`: rappresenta opzioni, preset e descrizioni caricati da YAML
  - `CampaignGenerateRequest`: rappresenta l'input utente inviato al service locale

## Dettagli implementativi

### `CampaignOptions`

Gestisce:

- liste di opzioni selezionabili (`settings`, `campaignTypes`, `themes`, `tones`, `styles`, `partyArchetypes`, `twists`)
- descrizioni testuali di ambientazioni e preset
- mappa completa dei preset

Helper esposti:

- `CampaignOptions.fromYaml(...)`: parsing del formato asset usato dall'app offline
- `CampaignOptions.fromJson(...)`: helper di compatibilita utile per fixture o test
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

## Regole di progettazione

- niente dipendenze da Flutter UI
- niente chiamate HTTP o accesso a `rootBundle`
- niente stato mutabile condiviso
- piccoli helper di dominio sono accettabili se riguardano il modello stesso

## Quando modificarla

Aggiorna questa cartella quando:

- cambia la struttura dei file YAML
- aggiungi nuovi campi alla flow del builder
- servono helper di parsing o normalizzazione legati al payload

Se un cambiamento riguarda layout, stili o interazioni visive, non appartiene qui.
