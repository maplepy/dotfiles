---
name: commit
description: Commit changes in logical groups with hook-formatted messages. Use when asked to commit, split changes into commits, or "/commit".
---

# Commit

The global `prepare-commit-msg` hook owns the header: it prefixes the type
with an emoji. Write the header in plain Conventional Commits and commit;
the hook decorates it.

## Workflow

1. Read `git status --short` and `git diff --staged` (fall back to `git diff`).
   Done when every changed path is accounted for.
2. Group paths into commits by concern, one atomic, self-contained change
   each. Split refactor from behavior change, formatting from logic, a
   dependency bump from unrelated code; keep a rename with its call sites and
   a schema with its migration. Done when every path belongs to exactly one
   group.
3. Commit each group in order: stage exactly its paths, then
   `git commit -m '<subject>'`, one `-m` per body paragraph. `git add -p` is
   interactive, so when a file mixes concerns, commit it with the concern that
   owns most of it and flag that in the report.
4. Done when every group is committed. Then run `git log --oneline -n <groups>`
   once and report each commit: hash, hook-decorated subject, and a one-line
   note on what it covers.

The default is committing. Produce paste-ready blocks instead only when the
user asks for just the message.

## Header

`<type>(<scope>)!: <imperative summary>`

- Hook types: `feat fix refactor perf docs test chore build ci deps revert style config init wip`.
- Any other type, or a missing one, is rewritten to `refactor`.
- Imperative mood: "add", "fix", "remove". 72 characters max, counting the hook's emoji.
- `<scope>` lowercase, one word. `!` marks a breaking change; the hook adds `💥` and keeps `!`.
- Plain text only: no AI attribution anywhere in the message.
- The hook leaves `fixup!`/`squash!`/`amend!`, `Revert`, merge and empty messages alone.

## Body

Why, breaking-change notes, migration steps, then `Closes #42` / `Refs #17`.
Wrap at 72, bullets `-`. The hook rewrites line 1 only; the body stays verbatim.

## Report

Only when the user asked for messages, hand back a paste-ready block
per commit: the `git add` line, then the message fenced.

````
git add src/auth/token.ts src/auth/token.test.ts
```
fix(auth): rotate refresh token before expiry

The old token expired mid-request; rotate it 30s early.

Closes #42
```
````
