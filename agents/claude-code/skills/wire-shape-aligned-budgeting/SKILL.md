---
name: wire-shape-aligned-budgeting
description: "Keep each wire message’s aggregate tool_result size within the configured budget by compacting the largest fresh results first."
metadata:
  author: ychampion
---

# SKILL: Wire-Shape Aligned Budgeting
**Domain:** tool-result-budget
**Trigger:** Apply this when building user messages that include multiple `tool_result` blocks to ensure the total stays under max tool results per message chars before the API call.
**Source Pattern:** Distilled from reviewed tool execution, streaming, persistence, and output-budget implementations.

## Core Method
Apply budgeting at the same level the wire protocol actually sends data: one outbound user message at a time. For each message, find the tool-result blocks that are eligible for replacement, immediately reapply any replacement decisions that were already frozen on earlier turns, and then compact the smallest number of newly oversized results needed to get under the limit. Persist or offload those large results, replace them with stable previews, and record the decision so retries, resumes, and forks keep producing the same message shape.

## Key Rules
- Treat replacement state as durable budgeting history; clone it for forks instead of mutating a shared object in place.
- Skip non-text or explicitly exempt results rather than trying to compact binary or protected payloads.
- Select new candidates by their original size, not by their preview size, so the algorithm removes the biggest pressure first.
- Reapply the exact stored preview for previously compacted results so prompt-cache shape stays stable across turns.
- Mark a decision durable at the same time you emit its preview so future turns do not re-decide the same result differently.

## Example Application
If a single user message contains several large tool results, run this budgeting pass before the API call. The largest fresh results get persisted and replaced with previews until the message fits, while already-compacted results keep their exact prior preview text.

## Anti-Patterns (What NOT to do)
- Avoid touching a message twice in the same turn; a second pass would reapply replacements again and break prompt-cache determinism.
- Don’t treat `frozen` IDs as fresh candidates; once a tool_result is seen, its fate is locked.
- Don’t persist results that already fit the budget just to create extra records—compact only when the limit is exceeded.
