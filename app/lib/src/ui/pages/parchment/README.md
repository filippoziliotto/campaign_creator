# parchment

Questa cartella contiene il layer dedicato alla schermata finale del prompt.
L'obiettivo e tenere separato il rendering della pergamena dalla shell e dalle route page, cosi il risultato finale puo evolvere senza contaminare il resto della flow.

## File

### `campaign_builder_parchment.dart`

Contiene:

- il parser del prompt finale in capitoli (`parsePromptChapters`)
- il reveal di ingresso del foglio (`ParchmentUnfoldReveal`)
- il foglio premium (`PremiumParchmentSheet`)
- la rail di azioni finali (`ParchmentActionRail`)
- i widget interni della pergamena: chapter tiles, highlight card, wax seal CTA, banner, stat chip

## Cosa deve stare qui

- trasformazione del prompt in una struttura leggibile
- presentazione del testo finale
- azioni direttamente collegate alla schermata finale
- motion specifica della pergamena

## Cosa non deve stare qui

- accesso diretto al service layer o agli asset bundle
- stato globale della flow
- logica di navigazione tra entry/forge/parchment

## Segnale pratico

Se una modifica riguarda “come appare e come si legge il prompt finale”, quasi certamente il punto giusto e questa cartella.
