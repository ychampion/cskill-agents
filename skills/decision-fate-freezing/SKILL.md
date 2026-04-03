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
Track every processed tool-result ID in durable budgeting state. Once a result has been evaluated, freeze its fate: either it stays inline forever or it is always replaced by the same persisted preview. Retries, forks, and resumed sessions must inherit that state and reapply the same decision instead of recalculating it. This keeps prompt shape stable and prevents the same result from flipping between full content and preview across turns.

## Key Rules
- Mark an ID as decided as soon as it becomes eligible, even if the outcome is “leave inline,” so later turns never re-open the decision.
- Store replacement previews only after persistence succeeds, and keep the decision marker and replacement payload in sync.
- Clone or reconstruct this state when forking or resuming so child threads inherit the exact same budgeting history.
- Log or persist every new replacement so resumes reapply the same preview string and the prompt cache stays intact.

## Example Application
If a large tool result is replaced with a persisted preview on turn 20, later retries and child agents should reuse that exact preview rather than reconsidering whether the full result can fit inline. The budgeting outcome for that result becomes part of the session state.

## Anti-Patterns (What NOT to do)
- Do not mutate seen ids only after persistence finishes, or a concurrent reader may treat the ID as fresh and replace it again on the same turn.
- Do not skip cloning or reconstructing the state for cache-sharing forks; that leads to inconsistent decisions between parent and child and breaks prompt caching.
- Do not update the replacements map without also marking the ID as seen — the next turn would treat it as fresh and potentially try to persist the same content twice.
