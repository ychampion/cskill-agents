---
name: built-in-agent-feature-gating
description: "Gate built-in agents based on feature flags and entrypoint types so SDK sessions stay lean."
metadata:
  author: ychampion
---

# SKILL: Built-In Agent Feature Gating
**Domain:** agent-management
**Trigger:** Use whenever agent registration should respect CLI entrypoints, SDK toggles, or feature flags before exposing the built-in catalog.
**Source Pattern:** Distilled from reviewed built-in agent registration and feature-flagged runtime catalog implementations.

## Core Method
Check entrypoint type, environment toggles, and feature flags before adding each built-in agent to the visible registry. Different entrypoints often need different built-in surfaces: a CLI may want planning or guidance agents, while an SDK or embedded runtime may want a minimal default set. Treat special orchestration modes as their own catalog variant rather than layering them on top of the normal list. This keeps built-in agents discoverable where they belong without leaking extra helpers into every runtime surface.

## Key Rules
- Support an explicit “disable built-ins” toggle for SDK or embedded contexts that should expose a minimal surface.
- Treat coordination or orchestration modes as a separate built-in catalog rather than mixing them into the default list.
- Gate specialized built-ins behind feature flags or experiments instead of making them permanently visible.
- Keep the gating logic centralized so every entrypoint evaluates the same rules consistently.

## Example Application
Before populating the agent registry, apply these checks so an SDK session can expose no built-ins, a CLI can expose planning or guidance agents when enabled, and a coordinator runtime can swap in its own worker-oriented catalog.

## Anti-Patterns (What NOT to do)
- Don’t register all built-in agents unconditionally; ignoring entrypoints or env vars breaks SDK/CLI separation.
- Avoid hardcoding agent lists per mode; fold them into feature flags and helper functions to stay configurable.

