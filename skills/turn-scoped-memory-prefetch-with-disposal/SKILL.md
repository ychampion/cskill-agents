---
name: turn-scoped-memory-prefetch-with-disposal
description: "Start a non-blocking, turn-scoped memory prefetch that auto-disposes and only injects results once per turn."
metadata:
  author: ychampion
---

# SKILL: Turn-Scoped Memory Prefetch with Disposal
**Domain:** context-management
**Trigger:** When a turn needs contextual memory attachments but the main loop must stay streaming and reuse previous read state.
**Source Pattern:** Distilled from reviewed session memory, compaction, and context-budgeting implementations.

## Core Method
Launch a memory prefetch exactly once at the start of the turn and keep its handle alive while the main loop streams. Each loop iteration should check whether the prefetch has completed without blocking on it; if not, continue streaming and check again later. When the prefetch is ready, deduplicate the returned attachments against what the session has already read, emit the new attachments once, and mark the handle as consumed so later iterations do not re-send them. Dispose of the handle automatically when the turn ends, aborts, or transitions so no background work leaks across turns.

## Key Rules
- Start the prefetch before the streaming loop begins and store its handle with the turn state so it cannot accidentally restart on subsequent iterations.
- Never block the main loop on the prefetch; poll readiness and continue streaming until the memory data is ready.
- Before adding attachments to the turn output, dedupe them against the cumulative read file state (or equivalent) so repeated memory hits from earlier iterations are skipped.
- After emitting attachments, set a consumed flag so downstream iterations skip re-emitting and the core method clearly signals it already produced this batch.
- Ensure the handle is disposed automatically when the generator exits, even when the turn aborts or transitions, to avoid leaked async work and to emit consistent telemetry.

## Example Application
If you build a new agent that reads documents for each user question, start a prefetch before streaming the model response, monitor the handle each loop, and only yield the resolved memories once so the UI can display them without delaying the primary response funnel.

## Anti-Patterns (What NOT to do)
- Re-running the prefetch on every iteration, which duplicates work and forces more disk/network traffic.
- Blocking the assistant loop by `await`ing the prefetch before the first attachment, which stalls streaming output for the turn.
- Emitting memory attachments without filtering against the cumulative read state, resulting in repeated or stale content.
