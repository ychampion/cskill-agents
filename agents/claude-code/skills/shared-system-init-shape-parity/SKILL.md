---
name: shared-system-init-shape-parity
description: "Centralize system init or capability payload construction in one builder so multiple transports emit identical schemas and only vary inputs or delivery."
metadata:
  author: ychampion
---

# SKILL: Shared System Init Shape Parity
**Domain:** transport-architecture
**Trigger:** Use when the same system init or capability-announcement payload is emitted from multiple entrypoints or transports and downstream clients depend on one stable schema.
**Source Pattern:** Distilled from reviewed remote-control, bridge transport, and capability-advertising implementations.

## Core Method
Define one canonical builder for the init payload and make every entrypoint call it. Put field names, defaults, derived state, feature-gated fields, and final key shaping inside that builder, not in the callers. Each transport path should do only path-local work: gather inputs, prefilter or redact collections when policy requires it, and choose when to send the message. This keeps the wire schema identical across stream, bridge, headless, or future transports so clients and tests do not drift between supposedly equivalent init events.

## Key Rules
- Make the shared builder own the full schema contract, including optional and feature-gated fields plus derived values such as session identifiers or fast-mode state.
- Let callers vary only inputs and delivery mechanics. They may filter commands, redact sensitive inventories, or load metadata asynchronously, but they should not hand-assemble sibling init objects.
- If two paths describe the same conceptual event, route both through the same builder even when one yields into a stream and another pushes via a bridge writer.
- Add new init fields once in the builder, then update callers only enough to supply the new inputs; never patch a field into one transport and plan to mirror it later.
- Keep transport-specific policy outside the builder when it truly differs by caller. The builder should serialize the canonical shape from supplied inputs, not decide privacy, bridge safety, or connection timing on its own.
- Review and test parity at the schema level, not just field-by-field intent, because drift usually appears as omitted, renamed, or differently defaulted keys.

## Example Application
A CLI has a normal query stream and a reconnecting remote bridge. The query engine emits the first init event by calling the shared init-payload builder. On bridge connect, the bridge path filters unsafe commands, redacts local integration inventories, and calls that same builder before sending its own init event. Both consumers receive the same key set and layout even though the collection contents differ.

## Anti-Patterns (What NOT to do)
- Do not duplicate system init object literals in separate transports; new fields will land in one path and silently disappear from another.
- Do not hide caller-specific policy inside the canonical builder if some transports need full metadata while others need filtered subsets.
- Do not justify a near-copy serializer just because one path is "only for bridge" or "only for headless"; once clients depend on it, it is part of the public wire contract.
