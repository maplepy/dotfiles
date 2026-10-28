---
name: pr
description: Merge request or PR title and body that reviewers can skim in under a minute, in English or French. Use when writing a PR, MR, or its description.
metadata:
  credits:
    skill: show-me
    author: Dex Horthy
    organisation: Humanlayer
    url: "https://github.com/humanlayer/skills/blob/main/plugins/show-me/skills/show-me/SKILL.md"
---

Write a title and body that let a reviewer understand the change without reading the diff first. Generates text only: no PR creation, no pushing.

## Steps

1. **Read the change.** Diff against the base (`git diff <base>...HEAD`) and `git log <base>..HEAD --oneline`. Collect issue references from commits and the branch name. Done when every changed file is placed in the Review guide or marked skippable.
2. **Pick the language.** Write in the language the user writes in. French: read [`fr.md`](fr.md) before writing.
3. **Write the title, then the body.** Skip preambles, keep prose brief, use the domain language from `GLOSSARY.md`.
4. **Skim test.** Reread as the reviewer: can the title and TL;DR alone say what changed and why? If not, rewrite them.

## Title

One line, ≤72 characters. Verb first, naming the behaviour that changes rather than the files touched. Add the reason when it fits. The tracker's ticket prefix goes first when the tracker needs one.

- Good: `Reject expired JWTs in the auth middleware`
- Bad: `Update auth.ts`, `Fixes`, `Various improvements`

## Body

```markdown
**TL;DR:** <what changed and why, 1-2 sentences>

## Summary

<view of the change>

## Review guide

1. Start: `<file>`, <what to check>
2. Scrutinize: `<file>`, <why it's risky>
3. Skim or skip: <generated, mechanical, renamed, moved>

## Evidence

- **Before:** <screenshot / output / failing test run>
  **After:** <screenshot / output / passing test run>

## Merge Danger

**Door:** <one-way or two-way>

**Blast Radius:** <one word>

<optional: ramifications>

Closes #42
Refs #17
```

Small change (one mechanical intent): keep TL;DR, a one-line testing note, and the links. Drop the rest.

Always keep when they apply: breaking changes (`BREAKING CHANGE:` line), migration notes, security implications, a testing line for database migrations, complex async logic, and external API changes. The tracker's own link format wins when it defines one.

### Summary

The smallest view that makes the key point clear: pseudocode, call tree, component tree, file tree, Mermaid, `diff`, or the whole block. Read [`summary-views.md`](summary-views.md) for the catalogue and examples.

### Review guide

Order files by where a reviewer should spend attention, not alphabetically. Name what to verify, not what the code does. Collapse noise in one line: "lockfile and snapshots regenerated", "17 files renamed, no logic change".

### Evidence

Show a before and after. Screenshots are S-tier when the change is visual and the environment allows it. Execution evidence is A-tier: the exact test that now fails and passes (pseudocode), or console output.

### Merge Danger

Door: a two-way door can be walked back, a one-way door cannot. Destructive actions and hard-to-reverse decisions are one-way. A PR cheap to roll back is lower risk.

Blast Radius: the scope of impact. Consider layout shift, breakage for consumers, mobile responsiveness, and every other surface the change reaches.
