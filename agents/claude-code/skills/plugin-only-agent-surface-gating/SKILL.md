---
name: plugin-only-agent-surface-gating
description: "Skip agent-declared MCP servers when strict plugin-only mode is active unless the agent is admin-trusted, keeping the session secure."
metadata:
  author: ychampion
---

# SKILL: Plugin-Only Agent Surface Gating
**Domain:** permission-gating
**Trigger:** Apply this when an agent tries to extend its MCP surface while the session enforces plugin-only MCP access.
**Source Pattern:** Distilled from reviewed agent trust-boundary and plugin-only surface-gating implementations.

## Core Method
Before connecting any agent-specific MCP servers, check whether the session is locked to plugin-only extension mode. If it is, allow the extra MCP connections only for trusted agent definitions such as built-ins or approved plugins. Untrusted or user-controlled agent definitions should continue without creating new clients, while logging the gating decision clearly. This prevents policy bypasses without breaking trusted packaged agents.

## Key Rules
- Check the plugin-only policy before any MCP initialization begins.
- Treat approved built-in or packaged agents as trusted, so their declared MCP integrations remain honored.
- Log a warning when skipping servers so telemetry captures the change in behavior.
- Always return the parent clients and an empty cleanup callback when gating is active to avoid downstream failures.

## Example Application
When running in a highly regulated environment, reuse this heuristic before initializing agent MCP servers so only pre-approved agents can expand the MCP surface and user scripts cannot sneak new servers in.

## Anti-Patterns (What NOT to do)
- Don’t let user-specified agents create external MCP connections while plugin-only mode is enabled; that defeats the security setting.
- Don’t apply the gate uniformly without checking admin trust; built-in agents still need their MCP servers even when plugin-only is true.

