---
name: project-root-scoped-local-skill-loading
description: "Resolve a stable project root first, then load local skills relative to that scope before combining them with other sources."
metadata:
  author: ychampion
---

# SKILL: Project-Root Scoped Local Skill Loading
**Domain:** skill-loading
**Trigger:** Apply when local commands or skills must be discovered from the current workspace and later merged with other registries such as MCP or bundled sources.
**Source Pattern:** Distilled from reviewed command-surface, skill-discovery, and CLI capability implementations.

## Core Method
Resolve the canonical project scope before loading any local command or skill surface. Feed that stable root into the local loader so discovery is anchored to the workspace boundary rather than to whatever transient working directory or caller context happened to invoke the pipeline. Once the local set is loaded from that scoped root, it can be safely merged with remote or external sources without mixing project-relative lookup with cross-source combination logic.

## Key Rules
- Determine a stable project root first and pass that explicit scope into the local skill loader.
- Keep local loading separate from later merge logic so source-specific discovery remains easy to reason about.
- Treat the project root as the authoritative boundary for local skills, not the caller's incidental cwd.
- Load the local project surface before combining it with external registries so downstream dedupe and formatting see one correctly scoped local set.

## Example Application
If a coding agent builds a skill listing from both the current repository and connected MCP servers, resolve the repository root first, load local skills relative to that root, then merge the resulting local commands with the MCP skills. This prevents a subdirectory invocation from silently narrowing the local skill surface.

## Anti-Patterns (What NOT to do)
- Do not call the local loader against an arbitrary runtime cwd when the real scope should be the project root.
- Do not intertwine project-root resolution with multi-source merging; local scoping should be correct before any external source is introduced.
