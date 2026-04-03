---
name: session-memory-first-compaction
description: "Attempt session-memory compaction before full conversation compaction so lightweight summaries win when available."
metadata:
  author: ychampion
---

# SKILL: Session Memory First Compaction
**Domain:** context-management  
**Trigger:** Apply when an auto-compact flow can query a session-memory summary before running the heavier legacy compaction path.
**Source Pattern:** Distilled from reviewed lightweight summary-first and fallback compaction implementations.

## Core Method
When auto-compaction fires, try the lightweight session-memory summary path first. If it returns a usable summary, treat that as a successful compaction and skip the heavier full-conversation compaction path. Only fall back to the heavyweight path when the lightweight summary is unavailable. This keeps cached or precomputed summaries in charge whenever possible and reserves the costly path for true misses.

## Key Rules
- Try the lightweight session-memory compaction path before the heavyweight full-conversation path every time auto-compaction triggers.
- On success, reset last summarized IDs and run any post-compact cleanup to keep boundary metadata in sync.
- Notify prompt-cache break detection so repeated compactions don’t misreport context flushes.
- Return early with `wasCompacted: true` so callers skip the fallback path.
- Only fall through to `compactConversation` when session memory compaction returns `null`.

## Example Application
Auto-compaction finds a fresh session-memory summary, accepts it as the compaction result, records success, and avoids calling the heavyweight compaction path at all.

## Anti-Patterns (What NOT to do)
- Don’t always run the heavyweight compaction first; you waste CPU and risk prompt-too-long errors that session memory could avoid.
- Don’t skip the cleanup steps that reset `lastSummarizedMessageId` and notify cache detectors when the lightweight path wins.

