---
name: three-layer-extension-sync
description: "Model extension lifecycle as intent, materialization, and active runtime layers, then sync each layer with dedicated transitions."
metadata:
  author: ychampion
---

# SKILL: Three-Layer Extension Sync
**Domain:** plugin-installation
**Trigger:** Apply when extensions exist simultaneously as declared settings, on-disk installs, and live runtime components, and those layers must stay coherent.
**Source Pattern:** Distilled from reviewed plugin, extension, and MCP synchronization implementations.

## Core Method
Split extension management into three layers: intent in configuration, materialization on disk, and active runtime state. Use the diff/reconcile phase to move layer 1 toward layer 2 without touching UI state, then use a separate refresh phase to rebuild layer 3 from the materialized result. This keeps each transition explicit, makes fallback rules clear, and prevents partial reload logic from smearing together configuration, installation, and activation responsibilities.

## Key Rules
- Give each layer a single owner: configuration declares desired state, reconciliation mutates on-disk artifacts, and runtime refresh repopulates active commands, agents, hooks, and servers.
- Compare intent to materialization before doing work so you know whether to install, update, skip, or defer.
- Treat reconciliation as additive and side-effect-bounded; it should not directly mutate live AppState beyond progress or recovery flags.
- Refresh the active layer from cleared caches after materialization changes so runtime loaders rebuild from the new disk state instead of patching stale objects in place.
- Make escalation explicit: urgent changes can auto-refresh, while less urgent ones can stop at a needs refresh contract.

## Example Application
In a desktop agent with third-party extensions, treat settings as the declared catalog, a local extensions directory as the materialized layer, and the in-memory command registry as the active layer. Reconcile settings to disk first, then run a distinct reload step that repopulates the active registry from the updated install set.

## Anti-Patterns (What NOT to do)
- Do not let a single function both clone marketplaces and directly mutate live component registries; that blurs error handling and recovery.
- Do not compare runtime state back to settings as a proxy for disk state; materialization needs its own truth source.
- Do not patch active components incrementally against stale caches when the on-disk layer changed underneath them.
