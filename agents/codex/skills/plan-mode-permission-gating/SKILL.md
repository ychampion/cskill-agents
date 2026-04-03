---
name: plan-mode-permission-gating
description: "Gate plan mode entry with permission updates so complex tasks run in a controlled, reviewable state."
metadata:
  author: ychampion
---

# SKILL: Plan Mode Permission Gating
**Domain:** permission-gating
**Trigger:** Invoke when the user wants to enter plan mode or a complex implementation requires additional permission scrutiny before introducing file edits.
**Source Pattern:** Distilled from reviewed plan-mode entry and permission-transition implementations.

## Core Method
Wrap plan-mode entry in an explicit permission transition. Validate that the request comes from the root session, switch the shared permission context into a planning state, and emit a standardized banner that reminds agents to explore before editing. Centralizing that transition prevents individual call sites from bypassing the plan-mode contract or drifting into edits before planning is complete.

## Key Rules
- Treat plan-mode entry as a read-only permission change that cannot be invoked inside a child-agent context.
- Reconfigure the shared permission context through one centralized transition path so state sync and side effects stay consistent.
- Return a human-facing banner describing the plan-mode obligations, and let follow-up instructions adapt to the active plan-mode variant.
- Keep the tool’s UI payload minimal but explicit about the no-edit rule; reuse the same instructions for both regular and interview-enhanced plan mode.

## Example Application
Use this skill when a CLI state machine detects a non-trivial refactor request: enter plan mode first, flip the session into a no-edit planning state, and require a reviewed plan before touching files.

## Anti-Patterns (What NOT to do)
- Don’t let a code path change permissions directly without the standardized transition, or some agents will edge into edits without the plan-mode reminder.
- Don’t ignore agent forks — the gate belongs only to the root session, so refuse plan-mode tool calls when `context.agentId` is set.

