---
name: deep-work
description: Execute a planned workflow autonomously without stopping to explain steps. Halts only for manual testing, missing information, or major ambiguity. Use when user wants to start deep work, run autonomously, or execute a plan without interruptions.
---

# Deep Work Mode

## Quick start

Before beginning autonomous execution, you must finalize the plan. Ask the user:
> "Do you want to run a quick `grill-me` (standard stress-test) or `grill-with-docs` (checks against project docs) before we start executing?"

Once the grilling is complete and the plan is solid, enter **Deep Work Mode**.

## Workflows

### Execution 
While in Deep Work Mode, follow these rules strictly:
1. **Silent Execution:** Work step-by-step through the plan using tools. DO NOT stop to explain intermediate steps, output progress summaries, or ask for permission for standard operations (reading/writing files, running tests).
2. **Auto-Fixing:** If you encounter a bug, test failure, or bash error, attempt to fix it autonomously using your tools. Read logs, edit code, and retry. 
   - **Loop Prevention:** If the same test or bash command fails 3 times in a row, consider yourself stuck in a loop, halt, and ask the user for help.
3. **Task Tracking:** Use the `todowrite` tool internally to track progress without bothering the user with play-by-plays.

### Halting Conditions
STOP autonomous execution and wait for user input **ONLY** when:
- **Missing Information:** You need an environment variable, secret, specific user preference, or context not found in the codebase.
- **Manual Testing Required:** A UI change, visual asset, external integration, or workflow requires a human to click around or verify visually.
- **Major Ambiguity:** An architectural crossroad appears that wasn't covered in the grilling phase, or a foundational assumption proves false.
- **Loop Detected:** You have failed to fix the same error 3 times in a row.

When halting, briefly explain exactly what you are blocked on or need tested, and wait for the user. 
**Resuming:** When the user provides the missing information, resolves the block, or confirms the manual test passed, automatically resume Deep Work silent execution without asking for permission.
