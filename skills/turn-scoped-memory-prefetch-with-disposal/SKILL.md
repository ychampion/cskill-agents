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
Launch an async memory prefetch exactly once at the beginning of the user turn and keep the returned handle through the streaming loop. Each iteration checks if the prefetch settled at timestamp is set and whether it has already been consumed; if it is not ready yet, skip the wait and re-evaluate on the next iteration so the main loop never blocks waiting for memories. Once the promise resolves, pass the attachments through a dedup layer that compares them against the cumulative read state so duplicates across iterations are suppressed, emit them only once, and mark the structure consumed on iteration so future iterations know not to reapply them. Wrap the prefetch in a disposal scope (`using` or equivalent) so cancellation, early exits, or turn transitions always release resources and signal telemetry about the prefetch lifetime.

## Key Rules
- Start the prefetch before the streaming loop begins and store its handle with the turn state so it cannot accidentally restart on subsequent iterations.
- Never await the prefetch on the main path; only read settled at and resolve the promise inside a zero-wait guard so the loop continues streaming while the I/O completes.
- Before adding attachments to the turn output, dedupe them against the cumulative read file state (or equivalent) so repeated memory hits from earlier iterations are skipped.
- After emitting attachments, set a consumed flag so downstream iterations skip re-emitting and the core method clearly signals it already produced this batch.
- Ensure the handle is disposed automatically when the generator exits, even when the turn aborts or transitions, to avoid leaked async work and to emit consistent telemetry.

## Example Application
If you build a new agent that reads documents for each user question, start a prefetch before streaming the model response, monitor the handle each loop, and only yield the resolved memories once so the UI can display them without delaying the primary response funnel.

## Anti-Patterns (What NOT to do)
- Re-running the prefetch on every iteration, which duplicates work and forces more disk/network traffic.
- Blocking the assistant loop by `await`ing the prefetch before the first attachment, which stalls streaming output for the turn.
- Emitting memory attachments without filtering against the cumulative read state, resulting in repeated or stale content.
