---
name: commit-workflow
description: "Inspect repo changes and automatically stage + commit granularly and atomically using your prefix conventions. Use when you have mixed unstaged changes and want them split intelligently into atomic commits with proper messages."
argument-hint: "Optional: describe which changes to process, or leave blank to auto-detect all"
---

# Commit workflow (guided atomic automation)

## When to use
- You have unstaged changes mixing multiple concerns (tests, docs, implementation)
- You want them split into atomic commits automatically
- You want guided approval before each commit
- You value consistency in commit messages and emoji

## How it works

This skill performs a 5-stage flow:

1. **Inspect**: Run `git status` and `git diff --stat` to see all changes
2. **Categorise**: Group files by type (tests, docs, source, config, etc.)
3. **Suggest**: Propose atomic commits with inferred type/scope and message
4. **Approve**: You review each proposed commit and approve, adjust, or reject
5. **Execute**: Stage and commit each approved batch; hook adds emoji

## Supported prefixes

- init (first commit in repo)
- feat (new behaviour)
- fix (bug fixes)
- fix (security concerns)
- docs (documentation)
- style (formatting/linting)
- refactor (internal structure)
- perf (performance)
- test (tests only)
- build (build system)
- ci (CI/CD pipeline)
- deps (dependency updates)
- revert (rollback commits)
- wip (work in progress, local only)
- config (config files)

## Procedure

### Stage 1: Inspect changes
- Show `git status` output
- Show `git diff --stat` (files changed, lines added/removed)
- Identify unstaged vs staged files
- Ask: "Process all changes, or filter by pattern?" (optional, default: all)

### Stage 2: Categorise by concern
- **Tests**: `**/test.ts`, `**/spec.ts`, `**/*.test.js`, `test/**`, `tests/**`
- **Docs**: `*.md`, `docs/**`, `README*`, `CHANGELOG*`, `*.mdx`
- **Config**: `.eslintrc*`, `.prettierrc*`, `tsconfig.json`, `package.json`, `.github/**`, `.env*`
- **Build/CI**: `Dockerfile`, `*.yml` (workflows), `build/**`, `scripts/**`
- **Source**: Everything else (implementation, lib, src)

### Stage 3: Suggest atomic commits
For each category, propose:
- **Inferred prefix** based on category (test → test, docs → docs, etc.)
- **Inferred scope** from changed files (e.g., "auth", "api", "ui")
- **Suggested message** from diff analysis (stateless functions, clear intent)
- **Files included** (list of staged files)
- **Breaking?** (ask if any are destructive/signature changes)

### Stage 4: Get approval (using @askQuestions)
For each proposed commit, use the askQuestions tool to present:
- Commit number and count (e.g., "1 of 3")
- **Prefix**, **Scope**, **Message**, **Files** (read-only display)
- **Breaking change?** (yes/no question)
- **Action** (Approve / Edit message / Skip)

User responds:
- **Approve**: Accept and move to next
- **Edit**: Modify the message inline and confirm
- **Skip**: Don't commit this batch (leaves files unstaged)
- **Breaking change**: If yes, append `!` and add footer

### Stage 5: Execute commits (targeted staging)
For each approved batch:
1. **Stage files explicitly**: `git add tests/auth.test.ts` (NOT `git add -A`)
   - Only stage files in this commit
   - Preserves other unstaged files for later commits
2. Generate message: `<prefix>(<scope>)<!>: <message>` (with `!` if breaking)
3. Commit: `git commit -m "..."`
4. Hook auto-adds emoji
5. Show result: `✨ test(auth): add token expiry validation tests`
6. Repeat for next approved batch

Show summary: "3 commits created, 12 files changed, 0 files remaining unstaged"

---

## Breaking changes

If a commit involves breaking changes:
- Ask: "Is this a breaking change?"
- If yes, append `!` to message: `feat(api)!: ...`
- Add footer: `BREAKING CHANGE: <what changed>`
- Hook prepends 💥

---

## Example flow

**Initial state**: 8 unstaged files, mixed concerns

```
Modified:   src/auth.ts (implementation)
Modified:   tests/auth.test.ts (new tests)
Modified:   README.md (docs)
Modified:   package.json (version bump)
```

**Skill output**:

Commit 1 of 3:
  Prefix:  test
  Scope:   auth
  Message: add token expiry validation tests
  Files:   tests/auth.test.ts
  [Approve]

Commit 2 of 3:
  Prefix:  fix
  Scope:   auth
  Message: validate token expiry on refresh
  Files:   src/auth.ts
  [Approve]

Commit 3 of 3:
  Prefix:  docs
  Scope:   auth
  Message: document token lifecycle
  Files:   README.md
  [Approve]

**After execution**:
```
✅ test(auth): add token expiry validation tests
🐛 fix(auth): validate token expiry on refresh
📝 docs(auth): document token lifecycle

3 atomic commits created.
```

---

## Tips

- Each commit uses targeted `git add <file1> <file2>`, never `git add -A`
- Files are staged only for their approved commit
- If you skip a batch, those files stay unstaged for manual handling
- Edit any message at approval stage via askQuestions; hook will still emoji-ify
- If two files could belong to different commits, the skill asks for clarification
- Dry-run mode: preview proposed commits without executing
- Safe to re-run: already-committed files are ignored
- View status after each commit: remaining unstaged changes listed
