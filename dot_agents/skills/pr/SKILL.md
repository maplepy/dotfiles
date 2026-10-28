---
name: pr
description: PR title and body in conventional-commit format, in English or French. Use when writing a PR or MR, its description, or a conventional commit title.
metadata:
  credits:
    skill: show-me
    author: Dex Horthy
    organisation: Humanlayer
    url: "https://github.com/humanlayer/skills/blob/main/plugins/show-me/skills/show-me/SKILL.md"
---

Write a PR title and body that is fast to review and ready to paste. Generates text only: no PR creation, no pushing.

## Steps

1. **Read the change.** Diff against the base (`git diff <base>...HEAD`) and `git log <base>..HEAD --oneline`. Collect issue references from commits and the branch name. Done when every changed file is accounted for in your head.
2. **Pick the language.** Write in the language the user writes in. French: read [`fr.md`](fr.md) before writing.
3. **Write the title.** See Title.
4. **Pick the density.** Terse when the change is one mechanical intent or the user asks for short; full otherwise.
5. **Write the body.** See Terse body or Full body. Skip preambles, keep prose brief, use the domain language from `GLOSSARY.md`.

## Title

`<type>(<scope>): <imperative summary>`

- Types: `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `chore`, `build`, `ci`, `style`.
- Scope optional. `!` before the colon marks a breaking change.
- ≤72 characters, imperative, lowercase, no trailing period.

## Terse body

```markdown
- <what, imperative>
- <what, imperative>

<why: one sentence, only if non-obvious>
<testing: one line, only if critical>

Closes #42
Refs #17
```

- Drop "This PR", "I", "we", pleasantries.
- Keep breaking changes (`BREAKING CHANGE:` footer), migration notes, security implications.
- Always add a testing line for database migrations, complex async logic, external API changes.
- Issue links last. The tracker's own format wins when it defines one.

## Full body

```markdown
## Summary

<view of the change>

## Evidence

- **Before:** <screenshot / output / failing test run>
  **After:** <screenshot / output / passing test run>

## Merge Danger

**Door:** <one-way or two-way>

<optional: description>

**Blast Radius:** <one word>

<optional: ramifications of the merge>
```

End with the issue links, same as terse.

### Summary

The smallest view that makes the key point clear: pseudocode, call tree, component tree, file tree, Mermaid, `diff`, or the whole block. Read [`summary-views.md`](summary-views.md) for the catalogue and examples.

### Evidence

Show a before and after. Screenshots are S-tier when the change is visual and the environment allows it. Execution evidence is A-tier: the exact test that now fails and passes (pseudocode), or console output.

### Merge Danger

Door: a two-way door can be walked back, a one-way door cannot. Destructive actions and hard-to-reverse decisions are one-way. A PR cheap to roll back is lower risk.

Blast Radius: the scope of impact. Consider layout shift, breakage for consumers, mobile responsiveness, and every other surface the change reaches.
