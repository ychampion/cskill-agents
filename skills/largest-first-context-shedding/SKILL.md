---
name: largest-first-context-shedding
description: "When a single API-level user message trips the per-message tool-result budget, drop the largest fresh results first so the model still receives the frozen context at the tightest budget point."
metadata:
  author: ychampion
---

# SKILL: Largest First Context Shedding
**Domain:** tool-result-budget
**Trigger:** Apply when one outbound user message exceeds the tool-result budget and you must decide which fresh results to replace first.
**Source Pattern:** Distilled from reviewed per-message budgeting and tool-result persistence implementations.

## Core Method
Gather eligible tool-result candidates per API-level message, keep track of the frozen size contributed by already-seen results, and sort the fresh candidates in descending size order. Subtract each candidate from the running total until the total drops beneath the budget. Replace only the selected large entries with persisted preview messages while leaving smaller or previously seen blocks untouched so the largest tokens are shed first.

## Key Rules
- Operate on the fresh subset so replacements never revisit previously frozen decisions.
- Sort descending by reported `size` and keep removing the largest entries, approximating their savings by subtracting their full size before the actual persistence preview is known.
- Always consider the frozen size when checking the over-budget condition; if the frozen entries alone exceed the limit, accept the overage rather than persisting already-broadcast content.
- Stop selecting once the running total is under the limit so you do not over-prune and unnecessarily persist more results than needed.

## Example Application
A user turn emits four tool-result blocks totaling 120k characters while the per-message budget is 50k. Select the two largest fresh results for persistence first, replace them with previews, and keep the smaller blocks inline if they still fit.

## Anti-Patterns (What NOT to do)
- Do not persist the smallest results first; that keeps the biggest token consumers in the context and never brings the message within budget.
- Do not recompute the sort on the entire conversation; the budget applies per message and frozen entries should not be reshuffled.
- Do not forget to subtract the frozen size when deciding whether to select more candidates; otherwise the budget loop will persist more content than necessary because it ignores what is already over the limit.

