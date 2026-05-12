---
name: dex
description: Use when tracking complex multi-step tasks, creating task hierarchies, maintaining persistent task state across sessions, building backlogs, or when the user explicitly asks to "use dex" for task management. Dex provides persistent memory for AI agents with GitHub/Shortcut sync capabilities.
---

# Dex - Persistent Task Tracking for AI Agents

Dex is a task tracking system for complex work — breaking down tasks, tracking progress, preserving context across sessions. Tasks stored as files in the repo.

## Use

If the package is installed, you can run `dex` commands in terminal. If not, install globally:

```bash
npm install -g @zeeg/dex
```

## Core Commands

```bash
dex                           # Dashboard: stats, ready, blocked, completed
dex list                      # Pending tasks (tree view)
dex list --all                # Include completed
dex list --ready              # Only unblocked
dex list --blocked            # Only blocked
dex list --in-progress        # Only in-progress
dex list --query "auth"       # Search

dex create "Task title" --description "Full context..."
dex create "Subtask" --parent <id>
dex create "Task" --blocked-by <id>

dex show <id>                 # View details
dex show <id> --full          # No truncation

dex edit <id> -n "New name"
dex edit <id> --description "Updated"
dex edit <id> --add-blocker <id>

dex start <id>                # Mark in progress
dex complete <id> --result "..." --commit <sha>
dex complete <id> --result "..." --no-commit
dex delete <id>

dex plan path/to/plan.md      # Create task from markdown plan
```

### Planning

```bash
dex plan path/to/plan.md        # Create task from markdown plan
```

For hierarchy breakdown (epic → tasks → subtasks), see `/dex-plan` command.

### GitHub/Shortcut

```bash
dex sync                        # Push tasks to GitHub/Shortcut
dex import #42                  # Import GitHub issue
dex import sc#123               # Import Shortcut story
```

## Verification

Every `dex complete` must include verification evidence:

```
# Strong:
"All 69 tests passing (4 new). Manually tested: valid token ✅, expired → 401."
Manually tested edge cases.

# Weak (avoid):
"Should work now" / "Made the changes" / "Added tests" (did they pass?)
```

## Writing Good Tasks

**Context** (what/why/how/done):
> Add rate limiting to /api/auth. express-rate-limit, 5 req/min for login, 20/min for refresh. Return 429 with Retry-After. src/middleware/rate-limit.ts.

Not: "Add rate limiting"

**Result** (what changed, decisions, verification):
> Added rate limiting with express-rate-limit. Login: 5/min, refresh: 20/min. Returns 429. All 30 tests passing.

Not: "Added rate limiting"

## Task Hierarchy

- **Epic**: Large initiative (5+ tasks). "Add user authentication system"
- **Task**: Significant work. "Implement JWT middleware"
- **Subtask**: Atomic step. "Add token verification function"

Max depth: 3 levels. Subtasks must complete before parent.

## When to Use

**Use when:** multi-session work, complex features needing breakdown, context preservation, handoffs, backlogs.
**Skip when:** quick single-session task, overhead not worth it.

## Workflow

1. `dex create "Feature" --description "full context"`
2. `dex create --parent <id> "Step 1" --description "..."`
3. `dex start <task-id>`
4. During work: `dex edit <id> --description "Updated context..."`
5. `dex complete <id> --result "verification evidence" --commit <sha>`

## Session Handoff

When ending with incomplete work:

```bash
dex edit <task_id> --description "
## Progress
- Done: JWT middleware
- WIP: Login endpoint (70%)
- Blocked: Need refresh token strategy
## Next
- Finish login validation
- Add refresh token rotation
"
```

Keep task `in_progress` so next session continues.
