# French PR output

Read when the PR is written in French. This file is the source of truth for what gets translated and what stays English.

## Stays English

Machine syntax and domain keywords. A translated keyword stops matching the code, the tracker, and the team's vocabulary.

- Conventional prefix, scope, and `!`: `feat(auth)!:`, never `fonctionnalité`.
- Footer tokens: `BREAKING CHANGE:`, `Closes`, `Refs`.
- Identifiers, paths, flags, test names, commands.
- Every term in the repo's `GLOSSARY.md`.
- Architecture and tooling keywords: layer, roleguard, guard, middleware, hook, endpoint, payload, token, cache, handler, resolver, provider, adapter, schema, migration, rollback, merge, rebase, lint, build, mock.

When unsure whether a word is a keyword, keep it English. Add new keywords to the list above as they come up.

## Translated

Prose: the title's summary, bullets, why, testing line, and the section content.

## Headings and labels

| English | French |
|---|---|
| Summary | Résumé |
| Evidence | Preuves |
| Merge Danger | Risque de fusion |
| Before / After | Avant / Après |
| Door: one-way / two-way | Porte : sens unique / réversible |
| Blast Radius | Rayon d'impact |

## Title grammar

Type and scope are English; the summary is French, infinitive mood (`ajouter`, `corriger`, `supprimer`), lowercase, no trailing period, ≤72 characters. No space before the colon: it is syntax, not prose.

```text
feat(auth): ajouter l'authentification JWT à l'API
fix(search): renvoyer toutes les lignes pour une requête vide
refactor(api)!: supprimer le endpoint /v1/orders
```

## Example

```markdown
fix(search): renvoyer toutes les lignes pour une requête vide

- Retourner la liste complète quand `q` est vide
- Avant: `/search?q=` renvoyait un 500

Test: `pytest tests/search_test.py::test_empty_query`

Closes #123
```
