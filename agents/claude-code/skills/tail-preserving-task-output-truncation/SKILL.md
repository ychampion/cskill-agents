---
name: tail-preserving-task-output-truncation
description: "Persist tool outputs alongside metadata and truncate only the preview, ensuring the header points back to the persisted replica."
metadata:
  author: ychampion
---

# SKILL: Tail-Preserving Task Output Truncation
**Domain:** task-output  
**Trigger:** Use this when a task produces output larger than the session’s configured limit and you need to keep a concise preview plus a persistent archive.  
**Source Pattern:** Distilled from reviewed tool execution, streaming, persistence, and output-budget implementations.

## Core Method
Track each task’s output size before emitting it. If it exceeds the configured limit, store the full output on disk, prepend a header that points to the saved file, and emit only the final slice of the log that still fits. Keeping the tail preserves the most recent progress or failure details while the persisted artifact holds the complete transcript.

## Key Rules
- Keep the configured output cap as the guardrail and only trim once per emission rather than chopping arbitrarily mid-stream.
- Write a clear header that points to the saved file so downstream readers can fetch the complete data on demand.
- After trimming, emit exactly available space characters from the end, not the start, so the most recent progress is preserved.
- Use a deterministic artifact path so every truncated preview points to a stable location.

## Example Application
When a build step emits 100 KB of logs, save the full output to a file such as `tool-results/build-task.txt`, then return only the tail of the log plus a header that tells the reader where the full output lives.

## Anti-Patterns (What NOT to do)
- Don’t trim from the beginning of the output where the useful part usually is.
- Don’t drop the header—the reader must know where to find the untrimmed record.
