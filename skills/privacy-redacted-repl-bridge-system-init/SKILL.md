---
name: privacy-redacted-repl-bridge-system-init
description: "Reuse one system init payload shape across trusted and remote transports, but redact tool, MCP, and plugin metadata when the bridge path would leak local integrations or filesystem paths."
metadata:
  author: ychampion
---

# SKILL: Privacy-Redacted REPL Bridge System Init
**Domain:** transport-privacy
**Trigger:** Use when the same session-init or capability payload is emitted to both trusted SDK/internal consumers and remote transports that may persist or forward the metadata.
**Source Pattern:** Distilled from reviewed remote-control, bridge transport, and capability-advertising implementations.

## Core Method
Centralize init-payload construction in one shared builder so every transport keeps the same wire shape. At the call site, classify the transport by trust and persistence. For trusted SDK or internal paths, pass the full tool, MCP, and plugin inventories because those consumers depend on complete metadata. For remote bridge or other persisted transports, reuse the same builder and field names but pass redacted substitutes for leak-prone collections, especially tool names that expose MCP integrations, MCP server descriptors, and plugin paths that reveal usernames or project layout. Preserve only the metadata the remote client actually needs, such as model, permission mode, remote-safe commands, agents, skills, and fast-mode state.

## Key Rules
- Reuse one payload builder for all paths; vary the inputs, not the schema, so clients and tests get shape parity.
- Treat any field that discloses local integrations or filesystem structure as sensitive on persisted or forwarded transports; in this seam that means `tools`, `mcp_servers`, and `plugins`.
- Redact by omission or empty collections rather than partially fabricating local details; the remote client should see "not advertised," not misleading host metadata.
- Keep trust-scoped fields that the remote UX genuinely needs, and further filter them to the remote-safe subset; for example, expose only bridge-safe slash commands rather than the full local command catalog.
- Allow fuller metadata on trusted SDK/internal paths where telemetry and UI consumers explicitly rely on it; the privacy rule is transport-specific, not a blanket removal everywhere.

## Example Application
A CLI emits system init into both its internal SDK stream and a phone bridge. Both paths call the same builder. The SDK stream passes full tools, MCP servers, and plugins so local integrators can render complete diagnostics. The bridge path passes empty arrays for those collections, but still includes model, permission mode, active agents, skills, and the subset of commands that are safe to invoke remotely.

## Anti-Patterns (What NOT to do)
- Do not fork two unrelated init schemas for trusted and remote clients; shape drift creates compatibility bugs and doubles maintenance.
- Do not forward plugin paths, MCP server names, or MCP-derived tool names into remote persisted storage just because they were convenient to collect locally.
- Do not over-redact fields that the remote product still depends on for gating or UI, such as permission mode or the remote-safe command list.
