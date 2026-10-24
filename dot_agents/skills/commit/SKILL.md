---
name: commit
description: Write git commit messages and split changes into commits. Use when staging changes, writing a commit message, splitting a commit, or "/commit".
---

# Commit

The global `prepare-commit-msg` hook owns the header: it prefixes the type
with an emoji. Write the header in plain Conventional Commits and let the
hook decorate it.

## Workflow

1. Read `git status --short` and `git diff --staged` (fall back to `git diff`).
   Done when every changed path is accounted for.
2. Group paths into commits, one concern each. Split refactor from behavior
   change, formatting from logic, a dependency bump from unrelated code. Keep
   a rename with its call sites and a schema with its migration. Done when
   every path belongs to exactly one commit.
3. Stage one group: `git add <paths>`, or `git add -p` for a mixed file.
4. Write the message per the rules below. Body only when the diff cannot
   explain the why.
5. Dry-run the header (below). Done when the output starts with the expected
   emoji and any `!` survived.
6. Hand back one paste-ready block per commit, in order. Commit only when asked.

## Header

`<type>(<scope>)!: <imperative summary>`

- Hook types: `feat fix refactor perf docs test chore build ci deps revert style config init wip`.
- Any other type, or a missing one, is rewritten to `refactor` — the dry-run catches it.
- Imperative mood: "add", "fix", "remove". 72 characters max, counting the hook's emoji.
- `<scope>` lowercase, one word. `!` marks a breaking change; the hook adds `💥` and keeps `!`.
- Plain text only: no AI attribution anywhere in the message.

## Body

Why, breaking-change notes, migration steps, then `Closes #42` / `Refs #17`.
Wrap at 72, bullets `-`. The hook rewrites line 1 only; the body stays verbatim.

## Dry-run

The hook fails silently by design, so check its rewrite before committing:

```bash
printf '%s\n' 'feat(api): add GET /users/:id/profile' > /tmp/msg
bash ~/.config/git/templates/hooks/prepare-commit-msg /tmp/msg message
cat /tmp/msg
```

Expect `✨ feat(api): add GET /users/:id/profile`. `♻️ refactor:` means the
type was rejected — fix the type, keep writing plain text. A second emoji
means the message already carried one. Unchanged output means the hook skipped
by design: message already emoji-prefixed, or a merge/squash/rebase/reuse
context.

## Output

One block per commit: the `git add` line, then the message fenced.

````
git add src/auth/token.ts src/auth/token.test.ts
```
fix(auth): rotate refresh token before expiry

The old token expired mid-request; rotate it 30s early.

Closes #42
```
````
