---
description: Convert markdown plan → dex task hierarchy (epic/tasks/subtasks)
agent: build
---

Convert the markdown plan at `$ARGUMENTS` into a dex task hierarchy.

## Step 1: Read & Parse

Read $ARGUMENTS. Extract title from first `# heading`. Strip "Plan: " prefix if present.

## Step 2: Determine Structure

Decide depth from document shape:

- `## Section` headers each with sub-items (numbered lists, ### headings) → **Epic + Tasks + Subtasks**
- Numbered steps (`1.` items) or `###` subsections under one `#` → **Task + Subtasks**
- One section, no sub-items, <10 lines → **Flat task**

**Break down when:** 3-7 distinct items, multiple files/components, sequential deps.
**Skip when:** 1-2 steps, single cohesive fix, exploratory, tightly coupled.

## Step 3: Create Hierarchy

### Flat task
Create one task with full file content as description.

### Task with subtasks
Create parent task with full content. For each step, `dex create "<description>" --parent <id> --description "..."` with relevant section content as context.

### Epic with tasks
Create epic with full content. For each `## section`, create a task (`--parent <epic-id>`) with section content. For sub-items within, create subtasks (`--parent <task-id>`).

## Step 4: Report

Return task IDs and a summary of the hierarchy created.

$ARGUMENTS
