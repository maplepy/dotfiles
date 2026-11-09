// vibecheck — "build checkpoints" plugin, inspired by vibe-wise
// (https://github.com/nykooi1/vibe-wise), adapted for OpenCode v2.
//
// Unlike a skill, this survives compaction: the checkpoint instructions are
// injected into every model call via session.hook("context"), not placed in
// chat history that can get summarized away.
//
// Toggle on/off per-session with slash commands:
//   /vibecheck-on   — require reasoning + confirmation before design/code
//   /vibecheck-off  — back to normal
//
// State is a flag file next to opencode's config, not per-project, so it
// persists across sessions until you flip it again. Delete the file or run
// /vibecheck-off to disable.

import fs from "fs"
import os from "os"
import path from "path"

const statePath = path.join(
  process.env.XDG_CONFIG_HOME || path.join(os.homedir(), ".config"),
  "opencode",
  ".vibecheck-active",
)

function isOn(): boolean {
  try {
    return fs.readFileSync(statePath, "utf8").trim() === "on"
  } catch {
    return false
  }
}

const INSTRUCTIONS = `VIBECHECK MODE ACTIVE — learning-first checkpoints

Core rule: describing what the user wants (a feature, a bug) sets the
REQUIREMENTS. It does NOT approve an architecture or implementation. Never
pick the design yourself and present it as done — the user owns every
non-trivial decision. Your job is to help them reason, not to decide for them.

Before designing or writing code for anything non-trivial, stop and checkpoint:

1. Build checkpoint: ask how THEY would approach it before you propose
   anything. If they're stuck, break the question down smaller, or explain
   any unfamiliar concept they need — but still end with a question that
   makes them reason, not with your answer.
2. Design checkpoint: once an approach emerges from them (or from discussion),
   restate it in 2-4 sentences as THEIR decision and ask "Confirm and
   continue" or "Discuss" before touching code. Confirming records the design;
   it is not yet permission to write code.
3. Implementation checkpoint: before writing, state exactly what you're about
   to change and why, then wait for "Implement this step" or "Discuss". Any
   extra detail you add beyond their decision (libraries, file layout) must be
   called out separately so they can question or override it.

After implementing: briefly explain what changed, how the key code works, why
it fits their decision, and what was tested — so they understand what was
built, not just that it was built.

Skip checkpoints only for trivial one-liners or when the user explicitly says
to just implement something without discussion.

Off: run /vibecheck-off.`

export default {
  id: "vibecheck",
  async setup(ctx: any) {
    await ctx.session.hook("context", (event: any) => {
      if (isOn()) event.system.push({ type: "text", text: INSTRUCTIONS })
    })

    await ctx.command.transform((editor: any) => {
      editor.add({
        name: "vibecheck-on",
        description: "Enable build/design/implementation checkpoints before coding",
        execute: async ({ sessionID }: { sessionID: string }) => {
          fs.writeFileSync(statePath, "on")
          await ctx.session.synthetic({ sessionID, text: "vibecheck: ON — checkpoints enabled." })
        },
      })
      editor.add({
        name: "vibecheck-off",
        description: "Disable vibecheck checkpoints",
        execute: async ({ sessionID }: { sessionID: string }) => {
          fs.writeFileSync(statePath, "off")
          await ctx.session.synthetic({ sessionID, text: "vibecheck: OFF." })
        },
      })
    })
  },
}
