---
name: autocompact-recursion-guards
description: "Block autocompact from running in recursive contexts so forks and helpers don’t deadlock."
metadata:
  author: ychampion
---

# SKILL: Autocompact Recursion Guards
**Domain:** context-management  
**Trigger:** Apply when auto-compacting logic runs inside recursive agents (session memory, compact helpers, context collapse) and must avoid deadlocking by re-entering itself.
**Source Pattern:** Distilled from reviewed session memory, compaction, and context-budgeting implementations.

## Core Method
Protect the proactive compaction gate with explicit exclusion rules for forked agents and context-specialized modes. Check whether the caller is already within the `session_memory` or `compact` subagent, whether a context-collapse or reactive-only mode is engaged, and whether features that manage their own context already control compaction. If any guard trips, return `false` so the recursion never fires again and the specialized agent can manage its own compaction cycle.

## Key Rules
- Identify contexts that already own compaction (session memory, compact, marble_origami, reactive compact, context collapse) and short-circuit the auto-compact decision for them.
- Keep the guards in should auto compact separate from the general thresholds so the recursion detection stays runnable even when feature flags change.
- Use feature gates to keep these checks dead-code-eliminated in builds that lack the implicated subsystems.
- Document why each guard exists so future engineers do not re-enable auto-compact in those contexts.
- Log or metrics may note when a guard prevented compaction so you can tune thresholds without reintroducing loops.

## Example Application
When a forked session-memory compactor would otherwise trigger auto-compact, the guard sees query source 'session memory' and returns `false`, letting the fork run its own compaction without conflicting with the main thread.

## Anti-Patterns (What NOT to do)
- Don’t let auto-compact run inside the compact agent or session memory; it will deadlock with itself.
- Don’t tie these guards to mutable thresholds; they must fire even when the token usage looks high.
