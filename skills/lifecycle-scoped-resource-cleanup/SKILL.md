---
name: lifecycle-scoped-resource-cleanup
description: "Release every agent-scoped resource in the `finally` block so spawning, aborting, or finishing an agent leaves no lingering clients, hooks, caches, or background tasks."
metadata:
  author: ychampion
---

# SKILL: Lifecycle-Scoped Resource Cleanup
**Domain:** lifecycle-management
**Trigger:** Each agent run, regardless of outcome, must unwind resources reserved for its lifetime without assuming the parent session will later re-claim them.
**Source Pattern:** Distilled from reviewed subagent orchestration, isolation, and lifecycle implementations.

## Core Method
Treat each child agent run as one lifecycle with a single unconditional cleanup path. After the run finishes, fails, or aborts, execute a predictable teardown sequence that disconnects per-agent integrations, unregisters hooks and watchers, clears temporary caches and staging state, removes agent-owned bookkeeping records, and stops any background jobs started on that agent’s behalf. Keep cleanup scoped to resources owned by that one agent so parent and sibling sessions remain untouched.

## Key Rules
- Run lifecycle cleanup from one unconditional `finally`/defer path so success, failure, and cancellation all converge on the same teardown logic.
- Guard optional cleanup steps with the same feature flags that created those resources in the first place.
- Remove agent-owned records entirely rather than leaving empty placeholders in shared state maps.
- Stop background jobs, hooks, and watches before the parent session can reuse the same identifiers or workspaces.

## Example Application
When a background workflow agent aborts due to timeout, these cleanup routines close MCP sockets, remove hooks that would fire on subsequent subagents, and kill orphaned shell loops so the terminal remains responsive.

## Anti-Patterns
- Do not perform cleanup only on the happy path or only in `catch`; missing the unconditional cleanup path leaves clients, hooks, or jobs running forever.
- Do not leave temporary caches or agent-owned state records behind after completion; stale state can leak memory and corrupt later runs.
