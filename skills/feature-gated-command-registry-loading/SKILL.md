---
name: feature-gated-command-registry-loading
description: "Assemble the command registry so optional modules only load when their feature flag is enabled and the registry is accessed."
metadata:
  author: ychampion
---

# SKILL: Feature-Gated Command Registry Loading
**Domain:** Command Architecture  
**Trigger:** Use when a command registry must gate optional commands behind feature flags and only initialize them when the registry is actually requested.  
**Source Pattern:** Distilled from reviewed command-surface, feature-gating, and lazy-registry implementations.

## Core Method
List the baseline commands normally, but place optional commands behind explicit feature checks so their modules do not load unless the feature is enabled. Build the registry lazily and cache the result after first access so startup does not pay for configuration reads or heavyweight command wiring. If you maintain companion registries such as internal-only or hidden commands, derive them from the same gated entries instead of rebuilding the logic in parallel.

## Key Rules
- Wrap each optional command in a feature check or runtime gate before loading its module.
- Build the registry inside a lazy cached function rather than at module scope.
- For any auxiliary command lists (internal, plugin, or plugin-derived), reuse the same filtered, feature-gated entries instead of recomputing or hardcoding duplicates.
- Keep metadata like `commandName`/`description` stable in the base list so the gating decision can focus solely on the inclusion of a `require`.

## Example Application
If you add an advanced `/insights` command, keep it behind a feature gate and load it only when the gate is enabled and the registry is requested. Users without that feature never pay the startup cost of the heavy module.

## Anti-Patterns (What NOT to do)
- Don’t unconditionally `import './commands/insights.js'` at the top level, which loads a massive module even when the feature is disabled.
- Don’t build the full registry during module initialization; that forces configuration reads and spills all commands into every consumer.
- Don’t create separate standalone registries per feature; use one memoized array and gate entries inside it to keep lookups predictable.

