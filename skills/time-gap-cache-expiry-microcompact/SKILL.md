---
name: time-gap-cache-expiry-microcompact
description: "When a long idle gap means the server cache is cold, clear old tool-result content before the next request instead of attempting warm-cache cache edits."
metadata:
  author: ychampion
---

# SKILL: Time-Gap Cache-Expiry Microcompact
**Domain:** compaction
**Trigger:** Apply when a long gap since the last assistant response implies the prompt cache has expired and cache-editing no longer makes sense.
**Source Pattern:** Distilled from reviewed session memory, compaction, and context-budgeting implementations.

## Core Method
Detect when the cache is effectively cold by comparing the idle gap against a time-based microcompact threshold. If the gap is too large, skip cache-editing entirely and proactively clear old tool-result content before the next request, because the full prefix will be rewritten anyway. Reset any cached microcompact state and suppress false-positive cache-break warnings so the cold-cache rewrite is treated as an intentional maintenance step.

## Key Rules
- Evaluate the idle gap only for explicit main-thread requests; analysis-only calls without a real query source should not trigger time-based compaction.
- Short-circuit before cache-editing when the gap exceeds the configured threshold, because cache edits assume a warm server cache.
- Reset shared cached-microcompact state after the content clear so stale registered tool IDs do not leak into later turns.
- Notify cache-break detection that the upcoming drop in cache reads is expected, not a genuine regression.
- Suppress compact warnings on successful time-gap cleanup so users do not get duplicate noise for the intentional clear.

## Example Application
If a user leaves a conversation idle for long enough that the server prompt cache is gone, clear old read/shell tool results before the next turn rather than trying to attach cache-edit instructions. The next request pays one clean rewrite cost and starts from a consistent compacted state.

## Anti-Patterns (What NOT to do)
- Do not attempt cache edits after a long idle gap; those edits assume cached server state that no longer exists.
- Do not leave cached microcompact state intact after a time-gap clear; stale tool registrations will poison the next edit cycle.
