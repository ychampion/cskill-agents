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
Iterate the servers declared by the child agent, resolve named references from shared MCP configuration, and treat inline declarations as new agent-owned connections. Merge the resulting clients and tools into the inherited parent context, but keep track of which connections were created specifically for that child agent. When the agent ends, tear down only those agent-owned connections while leaving inherited shared clients intact. If no extra servers are declared, return the parent context unchanged.

## Key Rules
- Short-circuit when the agent declares no extra MCP servers and return the inherited clients unchanged.
- For string specs, reuse memoized MCP configs; for inline objects, mark the resulting clients as newly created so their cleanup runs after the agent ends.
- Always return the merged client list plus the fetched tools, and expose a cleanup closure that only targets the newly created clients.
- Guard the loop with logging for missing configs so failures degrade gracefully instead of throwing.

## Example Application
When implementing a custom agent that needs access to an inline MCP server, plug into this skill to merge the new server with the parent clients, reuse any shared configs, and ensure only the inline connection runs its cleanup path.

## Anti-Patterns (What NOT to do)
- Don’t rebuild the entire MCP client list from scratch every turn; reuse the inherited parent clients and append the new ones instead.
- Don’t forget to clean up inline MCP servers; leaking them leaves dangling connections and stale credentials.
