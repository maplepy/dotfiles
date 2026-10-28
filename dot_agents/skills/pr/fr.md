# French PR output

Read when the PR is written in French. This file is the source of truth for what gets translated and what stays English.

## Stays English

Domain and machine keywords. A translated keyword stops matching the code, the tracker, and the team's vocabulary.

- Identifiers, paths, flags, test names, commands.
- Footer tokens: `BREAKING CHANGE:`, `Closes`, `Refs`.
- Every term in the repo's `GLOSSARY.md`.
- Architecture and tooling keywords: layer, roleguard, guard, middleware, hook, endpoint, payload, token, cache, handler, resolver, provider, adapter, schema, migration, rollback, merge, rebase, lint, build, mock.

When unsure whether a word is a keyword, keep it English. Add new keywords to the list above as they come up.

## Translated

Prose: the title, TL;DR, review guide, bullets, and the content of each section.

## Headings and labels

| English | French |
|---|---|
| TL;DR | En bref |
| Summary | Résumé |
| Review guide | Guide de revue |
| Start / Scrutinize / Skim or skip | Commencer / Examiner de près / Survoler ou ignorer |
| Evidence | Preuves |
| Before / After | Avant / Après |
| Merge Danger | Risque de fusion |
| Door: one-way / two-way | Porte : sens unique / réversible |
| Blast Radius | Rayon d'impact |

## Title

Same rules as English: one line, ≤72 characters, names the behaviour that changes. Infinitive mood (`Rejeter`, `Corriger`, `Supprimer`), capitalised first word, no trailing period.

- `Rejeter les JWT expirés dans le middleware d'auth`
- `Renvoyer toutes les lignes pour une requête vide`

## Example

```markdown
**En bref :** `/search?q=` vide renvoyait un 500, il renvoie maintenant la liste complète.

## Guide de revue

1. Commencer : `search.service.ts`, la garde sur `q` vide
2. Survoler ou ignorer : snapshots régénérés

## Preuves

- **Avant :** `GET /search?q=` → 500
  **Après :** `GET /search?q=` → 200, liste complète
- Test : `pytest tests/search_test.py::test_empty_query`

## Risque de fusion

**Porte :** réversible
**Rayon d'impact :** faible

Closes #123
```
