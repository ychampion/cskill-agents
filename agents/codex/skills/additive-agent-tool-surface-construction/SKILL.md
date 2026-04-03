---
name: additive-agent-tool-surface-construction
description: "Merge agent-specific tool sets (MCP clients + fetched tools) into the parent context without disrupting the parent’s existing pool."
metadata:
  author: ychampion
---

# SKILL: Additive Agent Tool Surface Construction
**Domain:** tool-surface
**Trigger:** Use this when bringing tools from newly connected MCP servers into the agent’s tool pool while preserving the parent context.
**Source Pattern:** Distilled from reviewed subagent orchestration, isolation, and lifecycle implementations.

## Core Method
When a child agent connects extra integrations, treat those capabilities as additions layered over the parent surface rather than as a replacement. Keep the parent client handles intact, append the agent-owned clients, and merge the newly discovered tool definitions alongside the inherited tool pool. Pass the merged clients, merged tools, and the child-owned cleanup handle downstream as one package so later stages can use the expanded surface without mutating the parent session.

## Key Rules
- Always start with parent clients and append agent clients in order to avoid losing existing handles that the session still needs.
- Maintain agent tools separately so the agent can union them with the parent’s command/skill catalog without overwriting it.
- Return both the merged clients and tools along with the cleanup closure so callers can pass them downstream transparently.
- Log the before/after counts to aid debugging when tools disappear unexpectedly.

## Example Application
When a sub-agent launches with extra MCP servers, use this pattern so it keeps the parent integrations it inherited while also gaining the newly connected agent-specific tools.

## Anti-Patterns (What NOT to do)
- Don’t replace the parent client list with just the agent’s clients; that loses the original MCP endpoints.
- Don’t forget to pass the merged tools through the helper that runs the forked agent, or the new MCP servers will appear to succeed but never expose their tools.
