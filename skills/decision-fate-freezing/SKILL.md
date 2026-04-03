---
name: decision-fate-freezing
description: "Freeze each tool result ID's replacement fate after it is observed so budget decisions stay deterministic across turns and forks."
metadata:
  author: ychampion
---

# SKILL: Decision Fate Freezing
**Domain:** tool-result-budget
**Trigger:** Apply when the message-level replacement budget runs and you need previously seen tool results to keep the same fate (persisted preview vs full content) even after resumes, forks, or cached prompts.
**Source Pattern:** Distilled from reviewed tool execution, streaming, persistence, and output-budget implementations.

## Core Method
Track every processed `tool_use_id` inside content replacement state so that once a result is marked as `seen` its fate is frozen: previously persisted blocks always reapplied via the `replacements` map, and previously unreplaced blocks are never reconsidered. apply tool result budget clones or reconstructs this state for forks and resumed threads so the same map/set pair stays in sync with the cached prompt prefix and enforces a deterministic budget outcome every turn.

## Key Rules
- Introduce seen ids entries as soon as a candidate is eligible, even if it does not get persisted, so later turns treat the ID as frozen and never change whether it was replaced.
- Populate `replacements` only when persistence succeeds and synchronize that update with the seen ids entry so clones see both or neither, keeping decisions atomic.
- Clone or reconstruct the state (clone content replacement state, reconstruct content replacement state) when forking threads so agentSummary, background agents, and resumed sessions inherit the exact same mapping and do not recompute different decisions later.
- Log or persist every new replacement so resumes reapply the same preview string and the prompt cache stays intact.

## Example Application
enforce tool result budget feeds content replacement state into apply tool result budget; every time a new user message triggers the budget, the helper marks the new IDs as seen and either writes replacements or leaves them untouched. When a resume or fork reuses that state, the previous decisions are re-applied byte-for-byte rather than recalculated.

## Anti-Patterns (What NOT to do)
- Do not mutate seen ids only after persistence finishes, or a concurrent reader may treat the ID as fresh and replace it again on the same turn.
- Do not skip cloning or reconstructing the state for cache-sharing forks; that leads to inconsistent decisions between parent and child and breaks prompt caching.
- Do not update the replacements map without also marking the ID as seen — the next turn would treat it as fresh and potentially try to persist the same content twice.
