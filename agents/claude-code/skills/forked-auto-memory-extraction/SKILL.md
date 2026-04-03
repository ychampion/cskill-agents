---
name: forked-auto-memory-extraction
description: "Run a forked agent that captures stable session context and writes auto memories when the main agent finishes a turn."
metadata:
  author: ychampion
---

# SKILL: Forked Auto Memory Extraction
**Domain:** background-extraction
**Trigger:** Use whenever memory harvesting must run in a background agent after the main turn completes so the main prompt stays responsive.
**Source Pattern:** Distilled from reviewed background memory extraction and forked-agent isolation implementations.

## Core Method
Spawn a forked memory-extraction agent after the parent turn finishes so the main session can stay responsive. Give the fork enough inherited context to understand the completed turn, but restrict its tools to a fenced set of read operations plus tightly scoped writes into the memory directory. The fork should save memories only when the main agent did not already persist the same content. This moves memory harvesting off the hot path without letting the background agent roam the rest of the workspace.

## Key Rules
- Build the extraction prompt from stable inherited turn context so the forked agent sees the same facts without mutating the main conversation.
- Fork children may only write into the memory directory and must not interact with the main conversation directly.
- Persist memories only when the main agent did not already save the same content; otherwise skip to avoid duplicates and race conditions.
- Treat the forked agent as fenced: read-only everywhere else, controlled writes only for the memory path.

## Example Application
When the user’s turn finishes with memory-worthy insights, dispatch this skill: the forked agent copies the last assistant message, runs the extraction prompt, and writes structured entries into `memory/*.md` while the parent stays in the REPL and accepts the next user question.

## Anti-Patterns (What NOT to do)
- Don’t run the extraction inside the main agent while it’s still processing the turn; that delays responses and can hit prompt budgets.
- Don’t let the forked agent use unrestricted shells or write outside the memory directory; keep it fenced to avoid privilege escalation or accidental file changes.

