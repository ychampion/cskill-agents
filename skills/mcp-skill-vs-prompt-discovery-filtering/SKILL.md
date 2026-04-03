---
name: mcp-skill-vs-prompt-discovery-filtering
description: "Ensure SkillTool only exposes MCP skills when they are registered as prompt-based commands and dedupe them against local commands."
metadata:
  author: ychampion
---

# SKILL: MCP Skill vs Prompt Discovery Filtering
**Domain:** tool-design
**Trigger:** Apply when SkillTool enumerates commands to decide which slash commands should be available, ensuring MCP prompt skills are disambiguated from generic prompts.
**Source Pattern:** Distilled from reviewed command discovery, MCP integration, and skill-surface implementations.

## Core Method
Inspect the MCP-discovered command surface, keep only entries that are actually prompt-based skills, and merge them with the local command registry into one unified list. Deduplicate by command name before validation or execution so MCP-discovered prompts cannot shadow or duplicate local skills by accident. Preserve source metadata so permission checks, telemetry, and UX can still tell whether a skill came from MCP or from a local registry.

## Key Rules
- Always filter MCP commands by `cmd.type === 'prompt'` before merging; prompts of other types should stay hidden because SkillTool only handles prompt-based skills.
- Merge the filtered MCP list with the local command registry and dedupe by name so remote skills do not conflict with bundled commands.
- Preserve metadata like `loadedFrom` or other source identifiers so permission checks and telemetry can tell whether the skill came from MCP or local registries.

## Example Application
If an MCP server exposes a prompt named `changelog` and the local registry already has one, run this filter before permission checks so the merged skill surface stays coherent and the MCP entry does not silently shadow the local one.

## Anti-Patterns (What NOT to do)
- Do not merge MCP prompts without filtering type or deduping, which would let MCP prompts masquerade as local skills and break strict permission rules.
- Do not treat MCP prompts as regular `prompt` commands without marking `loadedFrom:'mcp'`, because telemetry and permission prompts rely on knowing which commands were discovered versus bundled.


