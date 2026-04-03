---
name: bundled-and-mcp-turn-zero-skill-filter
description: "For first-turn skill listings, prefer a small bundled+MCP subset and fall back to bundled-only when the filtered set is still too large."
metadata:
  author: ychampion
---

# SKILL: Bundled-and-MCP Turn-Zero Skill Filter
**Domain:** skill-listing
**Trigger:** Apply when a first-turn skill listing must stay within a tight token budget, especially for subagents that cannot rely on the main thread's turn-zero discovery path.
**Source Pattern:** Distilled from reviewed first-turn listing and token-budgeting implementations.

## Core Method
When you need a small first-turn listing but the full skill registry is too large, filter down to the most intent-signaled sources first: bundled skills and user-connected MCP skills. If even that filtered set exceeds the safe listing budget, fall back again to bundled-only so the initial listing stays predictable and avoids truncation. This gives subagents a useful turn-zero surface without trying to announce the entire long tail of project, plugin, and user skills up front.

## Key Rules
- Start from the full registry but explicitly filter to the smallest high-signal sources rather than trying to compress every skill source equally.
- Enforce a hard cap for the filtered listing and define a deterministic fallback when that cap is exceeded.
- Prefer bundled skills as the final fallback because they are curated, stable, and less likely to explode in count than user-connected ecosystems.
- Leave the long tail of project, plugin, and user skills to later discovery flows instead of forcing them into the turn-zero listing.

## Example Application
If a spawned coding subagent needs a skill list on its first turn, offer bundled plus MCP skills while the total remains within budget. If the user has connected hundreds of MCP servers and that filtered list is still too large, show bundled skills only and rely on later discovery for the rest.

## Anti-Patterns (What NOT to do)
- Do not send the full skill registry on turn zero for every subagent; large installations will hit truncation and waste prompt budget.
- Do not choose an unstable fallback that depends on arbitrary ordering; the reduced listing should remain deterministic across runs.
