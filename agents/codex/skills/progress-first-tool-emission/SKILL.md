---
name: progress-first-tool-emission
description: "Emit progress/value updates as soon as they arrive while still buffering final results and handling cancellations or sibling errors."
metadata:
  author: ychampion
---

# SKILL: Progress-First Tool Emission
**Domain:** tool-orchestration  
**Trigger:** Streaming tool runners that produce progress messages or status updates alongside final tool results.  
**Source Pattern:** Distilled from reviewed tool execution, streaming, persistence, and output-budget implementations.

## Core Method
Track progress messages separately from final results by adding them to a dedicated buffer as soon as they arrive, and yield those messages to the user immediately, even while the tool is still running. Keep the final tool result buffered until the tool completes, and only then release it respecting the queue order. Handle cancellations, sibling errors, or streaming fallbacks by emitting synthetic tool error messages that describe the reason before closing the tool's slot, so the user sees a consistent progression of updates.

## Key Rules
- Emit progress lines instantly from their pendingProgress buffer while the tool is active; do not wait for full completion for updates that clarify status.
- When errors occur (user interrupt, streaming fallback, sibling error), craft a synthetic tool_result message explaining the cause and flush it before marking the tool completed.
- Keep context modifiers and results separated so progress does not mutate the shared context until the tool has fully finished and the ordered slot is ready to release new state.

## Example Application
For a CLI agent running shell commands that stream stdout/stderr, use this pattern so the UI gets progress-level updates (stream lines, spinner ticks) immediately, yet the final success/failure summary appears once the command finishes and in the correct sequential order relative to other tools.

## Anti-Patterns (What NOT to do)
- Treat progress output as part of the final result and hold it until the tool completes, which prevents the user from seeing real-time feedback.
- Drop synthetic error messages when canceling sibling tools, leaving the UI without an explanation for the aborted run.
- Let progress emissions mutate context or completion state before the tool is fully done, which can leave the shared context inconsistent.
