---
name: dex-first
description: Always plan multi-step work with dex before executing. Creates epics/tasks/subtasks following dex best practices.
---

# Dex-First Planning

## Core Behavior

**Before executing any multi-step work, plan it in dex first.**

When receiving a request that involves more than a single atomic action:

1. Break down the work into a dex structure (epic → task → subtask)
2. Create the tasks in dex with rich descriptions
3. Then execute them one by one, completing each with verified results

This applies to all significant work — features, refactors, migrations, investigations with multiple steps.

## Decision: When to Plan

**Plan with dex (create tasks first):**

- Work has 3+ distinct steps
- Multiple files or components involved
- Work could span sessions or benefit from context preservation
- Complex enough that tracking progress adds value

**Skip dex (just do it):**

- Single file edit, one-liner fix, quick answer
- Purely informational question
- Work is trivially atomic

## Workflow

### 1. Assess and Plan

On receiving multi-step work:

```bash
# Check what's already tracked
dex list

# Create the parent task or epic
dex create "Feature/goal name" --description "Full context:
- What: specific deliverable
- Why: motivation/background
- How: implementation approach
- Done when: acceptance criteria"

# Break into subtasks (3-7 per parent)
dex create --parent <id> "Step 1" --description "..."
dex create --parent <id> "Step 2" --description "..."
```

### 2. Execute Sequentially

Work through tasks in order:

```bash
dex list --ready    # What's unblocked?
dex show <id>       # Read full context before starting
```

### 3. Complete with Verification

After each task, verify and record:

```bash
dex complete <id> --result "What was done. Verification: all N tests passing."
```

## Hierarchy Guidelines

| Scope | Structure | Example |
|-------|-----------|---------|
| Small (1-2 files) | Single task | "Fix login validation bug" |
| Medium (3-7 steps) | Task + subtasks | "Add JWT auth" with 4 subtasks |
| Large (5+ areas) | Epic + tasks (+ subtasks) | "V2 API migration" with phases |

## Task Quality Standards

Every task description must answer:

- **What** needs to be done (specific, not vague)
- **Why** it's needed (background, motivation)
- **How** to approach it (files to modify, patterns to follow)
- **Done when** (acceptance criteria)

Every completion result must include:

- What was implemented
- Key decisions made
- Verification evidence (test counts, build status, manual testing)

## Resuming Work

When starting a session or asked "what's next":

```bash
dex list              # Check pending work
dex list --ready      # What's unblocked
dex show <id> --full  # Read context before continuing
```

Pick up where things left off. Don't re-plan what's already tracked.

## Dependencies

Use `--blocked-by` when task order matters:

```bash
dex create "Deploy" --blocked-by <test-task-id> --description "..."
```

## Key Rules

- **Plan before execute**: Create dex tasks before writing code for multi-step work
- **Never reference task IDs externally**: IDs are ephemeral; describe the work itself in commits/PRs
- **Complete subtasks before parents**: Bottom-up completion
- **3-7 children per parent**: Don't over-decompose
- **Verify before completing**: "Should work" is not verification
