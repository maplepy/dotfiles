---
name: caveman-pr-gen
description: >
  Ultra-compressed PR/merge request description generator. Cuts noise from PR descriptions
  while preserving what changed and why. Conventional format: title, bullets, linked issues.
  Use when user says "write a PR", "PR description", "generate PR", "/pr", or invokes
  /caveman-pr.
---

Write PR descriptions terse and exact. Conventional format. No fluff.

## Rules

**Title:**
- `<type>(<scope>): <imperative summary>`
- Types: `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `chore`, `build`, `ci`, `style`
- ≤72 chars total
- No trailing period

**Body:**
- Skip intro fluff ("I'm excited to share...", "This PR does...")
- Skip section headers if self-explanatory
- What: bullet list, imperative mood ("Add", "Fix", "Remove")
- Why: one sentence max, only if non-obvious
- Testing: one line, only if critical
- Link issues at end: `Closes #42`, `Refs #17`

**Drop:**
- "This PR", "I", "we"
- "I'm excited to share", "I'm happy to present", pleasantries
- Verbose changelog entries ("This commit adds the ability to...")
- Repeating what diff shows

**Keep:**
- Breaking changes (mark `!` or add BREAKING CHANGE section)
- Migration notes
- Security implications

## Examples

New feature:
```
feat(auth): add JWT auth for API

- Add `auth.service.ts` with login/verify
- Middleware checks Bearer token on /api/* routes
- JWT expiry 24h, refresh token 7d

Closes #42
```

Bug fix:
```
fix(search): null query returns all results

Previously `/search?q=` returned 500. Now returns full listing.
 regresion from #89

Closes #123
```

Breaking change:
```
refactor(api)!: remove /v1/orders endpoint

Clients must migrate to /v1/checkout before 2026-06-01.

BREAKING CHANGE: /v1/orders returns 410

Closes #56
```

## Auto-Clarity

Add brief testing note for: database migrations, complex async logic, external API changes.

## Boundaries

Only generates the PR description text. Does not create the PR, does not push branches. Output ready to paste. "stop caveman-pr" or "normal mode": revert to verbose PR style.
