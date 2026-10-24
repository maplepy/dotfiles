---
name: commit
description: Write and stage great git commits. Use when the user asks to commit, says "write a commit message", "split this commit", "/commit", or when changes are staged and a message is needed. Formats headers for the global prepare-commit-msg hook (Conventional Commits + gitmoji).
---

# Commit

The global `prepare-commit-msg` hook auto-prefixes the header with an emoji.
Write plain Conventional Commits; never type emoji, never type the prefix twice.

## Workflow

1. `git status --short` and `git diff --staged` (or `git diff` if nothing staged).
2. Group the changes into logical commits. One concern per commit.
3. Stage only that group: `git add <paths>`, or `git add -p` for mixed files.
4. Write the message, then verify the hook's rewrite (below) before committing.
5. Report each commit as a paste-ready code block; do not commit unless asked.

## Header

`<type>(<scope>)!: <imperative summary>`

- Types the hook knows: `init feat fix chore docs style refactor perf test build ci deps revert wip config`
- Anything else (including no type) is rewritten to `refactor` and lowercased — fix that before committing.
- Scope optional, lowercase, one word: `(api)`, `(auth)`, `(ui)`.
- `!` marks a breaking change; the hook adds `💥` and keeps `!`.
- Imperative: "add", "fix", "remove" — not "added"/"adds". No trailing period.
- ≤50 chars ideal, 72 hard cap. Hook result adds ~3 chars.

## Body

Only when the reason is not obvious from the diff: why, breaking-change
notes, migration steps, linked issues. Wrap at 72. Bullets `-`.
End with `Closes #42` / `Refs #17`. The hook only rewrites line 1; the body
is left verbatim.

Never: "this commit", "I", "we", "now", AI attribution, emoji.

## Splitting

Split when a diff mixes concerns: refactor + behavior change, dependency
bump + code using it, formatting + logic, tests for something unrelated.
Keep together when a change is meaningless alone (rename + its call sites,
schema + migration). If the user asks for one commit covering unrelated
work, say which lines split and ask, then default to the split.

## Verify the hook rewrite

Run before every commit — the hook fails silently by design:

```bash
printf '%s\n' 'feat(api): add GET /users/:id/profile' > /tmp/msg
bash ~/.config/git/templates/hooks/prepare-commit-msg /tmp/msg message
cat /tmp/msg
```

Expect `✨ feat(api): add GET /users/:id/profile`. If you see `♻️ refactor:`
the type was wrong. If the emoji is doubled, the message already had one.
The hook skips merge/squash/rebase/`-C`-reuse contexts, so unchanged output
there is normal.

## Output

One block per commit, in order, with the paths to stage:

````
git add src/auth/token.ts src/auth/token.test.ts
```
fix(auth): rotate refresh token before expiry

Closes #42
```
````

Subject-only when the diff explains itself. No summary of what changed.
