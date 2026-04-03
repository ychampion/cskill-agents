---
name: subagent-metrics-bridging
description: "Translate a streaming subagent run into task progress, analytics, and notifications while keeping partial results and cleanup tidy."
metadata:
  author: ychampion
---

# SKILL: Subagent Metrics Bridging
**Domain:** metrics-bridging
**Trigger:** Use when an async subagent loop needs to feed its token/tool-use counts, progress, and completion status back into the host task/analytics stack.
**Source Pattern:** Distilled from reviewed async subagent lifecycle, task-progress, and analytics bridge implementations.

## Core Method
Drive the async child-agent lifecycle through one progress bridge that feeds task UI, analytics, and notifications from the same stream. As messages arrive, update visible progress, token counts, and the last-active tool so the host can show meaningful live state. When the stream finishes, finalize the result once, record analytics from that finalized snapshot, and then emit completion notifications or warnings. Heavy post-processing should happen after the task is already marked complete so diagnostics do not block the visible lifecycle.

## Key Rules
- Move the visible task status to completed or terminated before running expensive diagnostics or cleanup.
- Derive progress, token counts, and “last tool used” from one shared tracker instead of recomputing them in multiple places.
- Finalize the child-agent result once and use that same finalized snapshot for analytics, notifications, and partial-result handling.
- On aborts or kills, still emit a clean closing notification so the parent task can resolve deterministically.
- Clear agent-specific transient state after every outcome so later runs do not inherit stale progress or artifacts.

## Example Application
When adding a new background worker that prefetches repo data for the user, follow this pattern to link its stream to the task UI/notification system and guarantee the analytics pipeline records its token tally even if it aborts midflight.

## Anti-Patterns (What NOT to do)
- Don’t log the completion event before the agent result is finalized—duplicated token counts appear if you emit analytics prior to `finalizeAgentTool`.
- Don’t rely on the final assistant message to always contain text; fallback logic exists inside `finalizeAgentTool` to pull the last text block, so duplicating that logic invites bugs.
