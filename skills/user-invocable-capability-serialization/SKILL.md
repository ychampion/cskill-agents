---
name: user-invocable-capability-serialization
description: "Serialize announced command and skill surfaces from a shared capability shape, excluding entries explicitly marked non-user-invocable."
metadata:
  author: ychampion
---

# SKILL: User-Invocable Capability Serialization
**Domain:** command-architecture
**Trigger:** Use when a session-init payload or capability announcement is projecting commands, skills, or similar affordances into a user-visible surface and some registry entries are internal-only.
**Source Pattern:** Distilled from reviewed remote-control, bridge transport, and capability-advertising implementations.

## Core Method
Normalize each advertised capability into a minimal shared shape that carries its public name plus an explicit user invocable flag. At the serialization boundary, drop every entry whose flag is `false`, then project the survivors into the wire format. Treat omitted flags as public by default so normal commands and skills stay easy to register, while hidden or internal capabilities can opt out without special-case serializers. Applying the same rule to both slash commands and skills keeps the announced surface aligned with what a user can actually invoke and prevents helper-only entries from leaking into discovery UIs.

## Key Rules
- Filter capabilities at the serialization boundary, right before projecting to plain strings or other user-facing wire fields.
- Use one shared capability shape and one shared user invocable rule across commands, skills, and similar announced surfaces so visibility policy stays consistent.
- Model hidden entries as an explicit opt-out (user invocable false) rather than scattered name-based exclusions.
- Treat missing user invocable as the common public case, but require internal helpers to set the flag explicitly so hidden behavior is intentional.
- Filter before mapping away metadata; once only names remain, the serializer can no longer distinguish public entries from internal ones.
- Let callers add stricter transport-specific filters upstream, but keep this generic user-invocable gate in the shared serializer.

## Example Application
A tool registry contains normal slash commands, an internal repair command, bundled skills, and a hidden diagnostic skill used only by automation. Convert both command and skill lists into name user invocable?, run the shared filter, and serialize only the entries not marked `false`. The resulting init payload shows the public commands and skills, while the internal repair and diagnostic entries never appear in the announced capability surface.

## Anti-Patterns (What NOT to do)
- Do not serialize the full registry and expect clients to guess which entries are internal.
- Do not keep separate visibility heuristics for commands and skills when they share the same announcement boundary.
- Do not rely on post-serialization cleanup of plain names; by then the visibility metadata is already gone.
- Do not assume hidden entries will stay hidden just because they are undocumented; internal-only status should be encoded directly in the capability metadata.
