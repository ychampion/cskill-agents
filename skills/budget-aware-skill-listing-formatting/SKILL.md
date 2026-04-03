---
name: budget-aware-skill-listing-formatting
description: "Derive the active model context budget at runtime and format skill listings to fit it instead of emitting raw command sets."
metadata:
  author: ychampion
---

# SKILL: Budget-Aware Skill Listing Formatting
**Domain:** skill-listing
**Trigger:** Apply when a skill or command listing must fit the active model's real context budget instead of assuming a fixed token allowance.
**Source Pattern:** Distilled from reviewed command-surface, skill-discovery, and CLI capability implementations.

## Core Method
Compute the formatting budget from the actual runtime model configuration rather than hard-coding a static limit. Ask the model/runtime layer for the current context window, including any beta-specific adjustments, then pass the candidate skill set through a formatter that trims or structures the listing to stay within that budget. This keeps the attachment aligned with whichever model is active and prevents a large registry from overflowing the prompt just because the runtime changed.

## Key Rules
- Derive the token budget from the active model and runtime flags at the time of formatting, not from a constant baked into the attachment code.
- Feed the budgeted formatter only the delta set that actually needs to be announced, not the entire registry every time.
- Keep budget calculation and formatting adjacent so future model changes cannot update one without the other.
- Treat formatting as a budget-enforcement step, not just string rendering; if the budget shrinks, the emitted listing must shrink too.

## Example Application
If a coding agent can run under different model sizes, first resolve that session's context window from the selected model and beta flags, then format the newly available slash commands so the attachment fits inside that window. A smaller model gets a tighter listing automatically without maintaining a second code path.

## Anti-Patterns (What NOT to do)
- Do not dump the raw command list directly into the prompt and hope the active model has enough room.
- Do not hard-code one token limit for every model; listings that fit one runtime may overflow another.
