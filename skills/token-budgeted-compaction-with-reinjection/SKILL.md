---
name: token-budgeted-compaction-with-reinjection
description: "Keep compaction budgets under control by compacting incrementally and reinjecting truncated attachments only when the reasoning surface remains stable."
metadata:
  author: ychampion
---

# SKILL: Token Budgeted Compaction With Reinjection
**Domain:** compaction
**Trigger:** Use when session history is growing toward the API limit and you need a safe way to trim older context while still reinjecting critical artifacts like skill metadata.
**Source Pattern:** Distilled from reviewed session memory, compaction, and context-budgeting implementations.

## Core Method
Run compaction in capped batches tied to a per-skill token budget: truncate each skill/document to <= 5k tokens, enforce an overall skill budget (25k tokens), bubble up warnings when budgets are hit, and only reinject the trimmed content when downstream turns request it. Keep a reusable helper that resets the per-skill counters after a compact run so the next turn starts from a clean slate.

## Key Rules
- Truncate at most the allowed per-skill token amount and track how many tokens were retained; this becomes the compact summary that can be reinjected later.
- Reserve a shared skills token budget and subtract each truncated skill from it; stop truncating once the budget is exhausted and emit a warning so the user knows some instructions were dropped.
- Reinjection occurs during the next turn only after the compact boundary moves; do not ring the same trimmed skill multiple times in one turn.
- Emit attachments for reinjected content so the downstream model can fetch specific sections rather than re-running the entire compact logic.

## Example Application
When a Claude Code conversation runs long, apply this skill to compact turns by triming per-skill summaries down to 5k tokens, track the remaining budget, warn when the budget is exhausted, and include the reinjected skill attachments alongside the next query so the model has the context it needs.

## Anti-Patterns (What NOT to do)
- Don't truncate skills arbitrarily without tracking their token costs; you need to know which instructions survived to explain compaction decisions to the user.
- Don't reinject the same trimmed data repeatedly in the same turn; the budget is about the current turn, so reinject only after a new compact boundary has been established.
