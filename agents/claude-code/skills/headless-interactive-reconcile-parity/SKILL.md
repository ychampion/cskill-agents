---
name: headless-interactive-reconcile-parity
description: "Keep interactive and headless extension installation flows behaviorally aligned by sharing reconciliation logic and adapting only the outer contract."
metadata:
  author: ychampion
---

# SKILL: Headless Interactive Reconcile Parity
**Domain:** plugin-installation
**Trigger:** Apply when the same extension installation lifecycle must work in both an interactive UI and a headless or automation mode.
**Source Pattern:** Distilled from reviewed plugin, extension, and MCP synchronization implementations.

## Core Method
Centralize the real install/reconcile behavior in shared lower-level helpers, then wrap it with thin mode-specific adapters. The interactive wrapper projects pending and progress state into AppState and may trigger user-facing refresh cues; the headless wrapper returns a simple changed/not-changed signal plus metrics. This preserves one source of truth for installation semantics while letting each mode expose the minimal contract its caller needs.

## Key Rules
- Share the diff, reconcile, and cache-invalidation primitives between modes; only the presentation and return type should differ.
- Let interactive mode add status mapping and manual-refresh prompts, but keep those concerns out of the headless path.
- Let headless mode return a boolean or compact metric set so its caller can decide whether to refresh downstream registries.
- Preserve environment-specific options, such as seed registration or zip-cache skips, as wrapper configuration instead of forking the core reconcile algorithm.
- Whenever marketplaces change, both modes must invalidate the caches that downstream loaders depend on.

## Example Application
If a coding agent can boot with a TUI or inside CI, route both startup paths through the same extension reconciler. The TUI path can paint per-source spinners, while the CI path just reports whether extensions changed and whether the caller should rebuild its command registry.

## Anti-Patterns (What NOT to do)
- Do not duplicate the install algorithm in two codepaths; they will drift on skip rules, cache behavior, and error handling.
- Do not leak interactive AppState updates into headless mode or force headless callers to emulate UI state they do not have.
- Do not let headless mode skip cache invalidation just because it lacks a visual progress surface.
