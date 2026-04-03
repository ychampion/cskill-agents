---
name: agent-specific-mcp-server-initialization
description: "Connect each agent’s frontmatter MCP servers safely and tear them down without leaking clients, while honoring plugin-only guards."
metadata:
  author: ychampion
---

# SKILL: Agent-Specific MCP Server Initialization
**Domain:** mcp-initialization
**Trigger:** Load this skill when an agent defines extra MCP servers in its frontmatter and those clients must be joined to the parent session.
**Source Pattern:** Distilled from reviewed subagent orchestration, isolation, and lifecycle implementations.

## Core Method
Iterate the agent’s mcp servers, resolve named references via the shared MCP config cache, and treat inline specs as newly created clients that get cleaned up after the agent finishes. Merge the resulting clients and tools with the parent context, skipping the entire block if no servers are declared. Maintain a newly created clients list so only agent-owned MCPs are torn down, while shared ones stay available to the parent.

## Key Rules
- Short-circuit when mcp servers is empty and return the parent clients unchanged.
- For string specs, reuse memoized MCP configs; for inline objects, mark the resulting clients as newly created so their cleanup runs after the agent ends.
- Always return the merged client list plus the fetched tools, and expose a cleanup closure that only targets the newly created clients.
- Guard the loop with logging for missing configs so failures degrade gracefully instead of throwing.

## Example Application
When implementing a custom agent that needs access to an inline MCP server, plug into this skill to merge the new server with the parent clients, reuse any shared configs, and ensure only the inline connection runs its cleanup path.

## Anti-Patterns (What NOT to do)
- Don’t rebuild the entire MCP client list from scratch every turn; reuse parentClients and append the new ones instead.
- Don’t forget to clean up inline MCP servers; leaking them leaves dangling connections and stale credentials.
