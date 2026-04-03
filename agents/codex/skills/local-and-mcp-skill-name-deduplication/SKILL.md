---
name: local-and-mcp-skill-name-deduplication
description: "Merge local and MCP skill sources into one listing surface and dedupe by stable command name before announcing them."
metadata:
  author: ychampion
---

# SKILL: Local-and-MCP Skill Name Deduplication
**Domain:** skill-listing
**Trigger:** Apply when a listing surface combines commands from multiple registries or providers and must avoid announcing the same user-facing capability twice.
**Source Pattern:** Distilled from reviewed command-surface, skill-discovery, and CLI capability implementations.

## Core Method
Collect commands from each relevant source independently, then merge them into one announcement surface before any later filtering or formatting runs. Deduplicate the merged list by the stable user-facing command name rather than by source-specific IDs so identical capabilities from different providers collapse into one entry. This preserves broad coverage across local and remote registries while preventing the listing from double-counting equivalent commands simply because they were discovered through different backends.

## Key Rules
- Load each source separately first so the merge step remains explicit and future sources can be added without rewriting downstream logic.
- Deduplicate on the stable presentation key the user actually sees, such as command name, not on internal source identifiers.
- Run deduplication before later listing filters or formatting so downstream budget and delta logic operate on the real surface area.
- Keep the single-source fast path when secondary sources are empty so the common case stays simple and cheap.

## Example Application
If a coding agent can discover reusable skills from the current project and from connected MCP servers, gather both sets, merge them, and collapse entries that share the same slash-command name before rendering the skill catalog. The user sees one coherent listing instead of duplicates for the same command coming from different registries.

## Anti-Patterns (What NOT to do)
- Do not concatenate multiple registries and announce them raw; duplicate command names will inflate the listing and confuse consumers.
- Do not deduplicate on backend-specific IDs when the real collision happens at the user-visible command name.
