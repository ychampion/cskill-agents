---
name: reserved-summary-output-budget
description: "Reserve part of the context window for summary output so proactive compaction does not kill the response budget."
metadata:
  author: ychampion
---

# SKILL: Reserved Summary Output Budget
**Domain:** context-management  
**Trigger:** Apply when proving that proactive compaction must shrink the usable context window to keep the summary output under a known token budget.
**Source Pattern:** Distilled from reviewed session memory, compaction, and context-budgeting implementations.

## Core Method
Before inviting a compaction, shrink the effective context window by reserving room for the post-compaction summary (and any optionally re-injected skills/output). Calculate the base context window for the model, subtract a fixed upper bound on the summary tokens (20k here), and feed that reduced window to downstream budgeting logic so warning thresholds and blocking limits reflect the diminished headroom.

## Key Rules
- Base the reservation on the model’s max output tokens so languages with smaller outputs still reserve enough space.
- Keep the reserved summary allowance explicit and documented (e.g., max output tokens for summary 20 000) so future tweaks know why the window shrank.
- Derive warning/error thresholds from the reduced window so percent-left and blocking checks respect the reservation.
- Offer an override path (e.g., claude autocompact pct override or blocking limit overrides) to aid testing without losing the rationale.
- Treat the reserved portion as untouchable – only the remaining tokens count toward auto-compact triggers or manual compaction budgets.

## Example Application
When autocompact fires, compute the effective window as context window reserved summary tokens, then generate warnings based on that clipped value so autocompact threshold, warning threshold, and blocking limit stay consistent even though the API still sees the full context.

## Anti-Patterns (What NOT to do)
- Don’t ignore the summary tokens when computing thresholds; doing so lets the summary overflow the model’s output limit.
- Don’t hardcode warnings to the raw context window without documenting the inviolable reservation.
